#! /bin/sh

prompt_alexis_separating_line() {
  export _prompt_alexis_separating_line="\n"
}

prompt_alexis_host_info() {
  export _prompt_alexis_host_info="%n@%m "
}

prompt_alexis_pwd() {
  export _prompt_alexis_pwd="%{%F{green}%}%~%{%f%}\n"
}

prompt_alexis_last_command_status() {
  export _prompt_alexis_last_command_status="%{%(?.%F{green}.%F{red})%}⚡ %{%f%} "
}

_prompt_alexis_build_git_info() {
  enrich_append() {
    flag=$1
    text=$2
    if [ "${flag}" != "true" ]; then
      text="$(echo "${text}" | sed 's/./ /g')"
    fi

    echo "${text}"
  }
  get_symbol_for() {
    symbol_id=${1:-}
    symbol_idx=$(echo "${_prompt_alexis_git_symbols_map:-}" | grep "${symbol_id}:" | head -1 | cut -d':' -f2)
    echo "${_prompt_alexis_git_symbols:-}" | cut -d":" -f "${symbol_idx}"
  }

  git_line=""
  . "${_prompt_alexis_async_git_data:-}"

  if [ "${gbg_is_a_git_repo:-}" = "true" ]
  then

    git_line="${Black:-}${On_White:-}"
    git_line+=$(enrich_append "true" "$(get_symbol_for is_a_git_repo)")

    # on filesystem
    git_line+=$(enrich_append "${gbg_repo_has_stashes:-}" "$(get_symbol_for has_stashes)")

    git_line+="${Red:-""}"
    git_line+=$(enrich_append "${gbg_workspace_has_untracked:-}" "$(get_symbol_for has_untracked)")

    git_line+=$(enrich_append "${gbg_workspace_has_modifications:-}" "$(get_symbol_for has_workspace_mods)")
    git_line+=$(enrich_append "${gbg_workspace_has_deletions:-}" "$(get_symbol_for has_workspace_dels)")

    git_line+=" ${White:-}${On_Yellow:-}$(get_symbol_for separator)${Black} "

    # in index
    git_line+=$(enrich_append "${gbg_index_has_modifications:-}" "$(get_symbol_for has_index_mods)")
    git_line+=$(enrich_append "${gbg_index_has_moves:-}" "$(get_symbol_for has_index_moves)")
    git_line+=$(enrich_append "${gbg_index_has_additions:-}" "$(get_symbol_for has_index_adds)")
    git_line+=$(enrich_append "${gbg_index_has_deletions:-}" "$(get_symbol_for has_index_dels)")

    # Operation
    # TODO

    git_line+=" ${Yellow:-}${On_Red:-}$(get_symbol_for separator)${Black}"

    # Remote
    if [ "${gbg_head_is_detached:-}" = "true" ] # Detached state
    then
      git_line+="${White}"
      git_line+="$(get_symbol_for detached)"
      git_line+="${Black}"
      git_line+=" ${gbg_head_hash:-:0:7}"
    elif [ "${gbg_upstream_has_upstream:-}" = "false" ] # No upstream set
    then
      git_line+="${Black}"
      git_line+="-- "
      git_line+="${White}"
      git_line+="$(get_symbol_for not_tracked)"
      git_line+="${Black}"
      git_line+=" --"
      git_line+=" (${gbg_head_branch:-"???"}) "
    else # Standard branch
      git_line+="${Black}"
      if [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
        git_line+=" -${gbg_upstream_commits_behind_num}"
      else
        git_line+=" -- "
      fi

      if [ "${gbg_upstream_has_diverged:-}" = "true" ]
      then
        upstream_diff="$(get_symbol_for has_diverged)"
      elif [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
        upstream_diff="$(get_symbol_for can_ff)"
      elif [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
        upstream_diff="$(get_symbol_for should_push)"
      elif [ "${gbg_upstream_commits_ahead_num:-0}" -eq 0 ] && [ "${gbg_upstream_commits_behind_num:-0}" -eq 0 ]; then
        upstream_diff="  "
      fi
      git_line+="${White}"
      git_line+="${upstream_diff}"
      unset upstream_diff

      git_line+="${Black}"
      if [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
        git_line+=" +${gbg_upstream_commits_ahead_num} "
      else
        git_line+=" -- "
      fi

      git_line+=" (${gbg_head_branch} $(get_symbol_for "${gbg_upstream_merge_type:-merge}_tracking") ${gbg_upstream_name:-""//\/$gbg_head_branch/}) "
    fi

    git_line+=$(enrich_append "${gbg_head_is_on_tag:-}" "$(get_symbol_for tag) ${gbg_head_tag:-}")

    git_line+=" ${Red}${On_Default:-}$(get_symbol_for separator)${ColorReset:-}"

    echo "${git_line}"
    return 0
  else
    return 1
  fi
}

prompt_alexis_git_info() {
  if [ "${_prompt_alexis_async_git_pid:-}" -gt 0 ]; then
    # Append Git status.
    if [ -e "${_prompt_alexis_async_git_data:-}" ]; then
      _prompt_alexis_new_git_info="$(_prompt_alexis_build_git_info)"
      if [ -n "${_prompt_alexis_new_git_info}" ]
      then 
        _prompt_alexis_new_git_info="${_prompt_alexis_new_git_info}\n"
      fi
      if [ "${_prompt_alexis_new_git_info}" != "${_prompt_alexis_git_info}" ]; then
        export _prompt_alexis_git_info="${_prompt_alexis_new_git_info}"
        if [ -n "${_prompt_alexis_async_refresh_command:-}" ]; then
          eval "${_prompt_alexis_async_refresh_command}"
        fi
      fi
    fi

    # Reset async states.
    _prompt_alexis_async_git_pid=0
    rm -f "${_prompt_alexis_async_git_data}"
  fi
  set -m
}

prompt_alexis_git_line() {
  # TODO: don't use async on shell which doesn't support prompt redrawing
  # Kill the old process of slow commands if it is still running.
  if [ "${_prompt_alexis_async_git_pid:-0}" -gt 0 ]; then
    kill -SIGKILL "${_prompt_alexis_async_git_pid}" > /dev/null 2>&1
  fi

  _prompt_alexis_async_git_data="/tmp/prompt_alexis-${USER}-git"
  set +m
  trap prompt_alexis_git_info USR1
  prompt_alexis_async_git_line &
  _prompt_alexis_async_git_pid=$!
}

prompt_alexis_async_git_line() {
  # Get Git repository information.
  if [ "$(set | grep -c "gbg_git_info")" -eq 1 ]; then
    gbg_git_info
    export -p | grep -Ee "gbg_" | rev | cut -d' ' -f1 | rev >! "${_prompt_alexis_async_git_data:-/dev/null}"
  fi

  # Signal completion to parent process.
  kill -SIGUSR1 $$
}

prompt_alexis_precmd() {
  # Format the git line
  prompt_alexis_git_line

  # Format separating line
  prompt_alexis_separating_line

  # Format user/host info
  prompt_alexis_host_info

  # Format PWD.
  prompt_alexis_pwd

  # Format last command status
  prompt_alexis_last_command_status
}

prompt_alexis_build_prompt() {
  printf "%b" "${_prompt_alexis_separating_line}"
  printf "%b" "${_prompt_alexis_git_info}"
  printf "%b" "${_prompt_alexis_host_info}"
  printf "%b" "${_prompt_alexis_pwd}"
  printf "%b" "${_prompt_alexis_last_command_status}"
}
