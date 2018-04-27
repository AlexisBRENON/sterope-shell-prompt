#! /bin/sh

f_prompt_alexis_separating_line() {
  export v_prompt_alexis_separating_line="\n"
}

f_prompt_alexis_host_info() {
  v_prompt_alexis_host_info="$(whoami)@$(hostname | cut -d'.' -f1) "
  export v_prompt_alexis_host_info
}

f_prompt_alexis_pwd() {
  v_prompt_alexis_pwd="${Green:-}$(echo "${PWD}" | sed "s#^${HOME}#~#")${ColorReset:-}\n"
  export v_prompt_alexis_pwd
}

f_prompt_alexis_last_command_status() {
  l_prompt_alexis_yellow=""
  l_prompt_alexis_brown=""
  if [ -n "${ColorFontCode:-}" ]; then
    l_prompt_alexis_yellow="${ColorFontCode}226m"
    l_prompt_alexis_brown="${ColorFontCode}94m"
  fi
  if [ "${v_prompt_alexis_last_command_status:-1}" -eq 0 ]; then
    v_prompt_alexis_last_command_status="${l_prompt_alexis_yellow}✨"
  else
    v_prompt_alexis_last_command_status="${l_prompt_alexis_brown}💩"
  fi
  v_prompt_alexis_last_command_status="${v_prompt_alexis_last_command_status} ${ColorReset:-} "
  export v_prompt_alexis_last_command_status
}

f_prompt_alexis_git_line() {
  v_prompt_alexis_git_line=""
  if [ "$(set | grep -c "gbg_git_info")" -ge 1 ]; then
    gbg_git_info
    v_prompt_alexis_git_line="$(f_prompt_alexis_build_git_line)"
    if [ -n "${v_prompt_alexis_git_line}" ]
    then 
      v_prompt_alexis_git_line="${v_prompt_alexis_git_line}\n"
    fi
  fi
  export v_prompt_alexis_git_line
}

lf_prompt_alexis_enrich_append() {
  flag=$1
  text=$2
  if [ "${flag}" != "true" ]; then
    text="$(echo "${text}" | sed 's/./ /g')"
  fi

  echo "${text}"
}
lf_prompt_alexis_get_symbol_for() {
  symbol_id=${1:-}
  symbol_idx=$(echo "${v_prompt_alexis_git_symbols_map:-}" | grep "${symbol_id}:" | head -1 | cut -d':' -f2)
  echo "${v_prompt_alexis_git_symbols:-}" | cut -d":" -f "${symbol_idx}"
}
f_prompt_alexis_build_git_line() {
  if [ "${gbg_is_a_git_repo:-}" = "true" ]
  then
    # git repo infos
    l_prompt_alexis_git_line="${Black:-}${On_White:-}"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      basename "${gbg_repo_top_level}"\
    )"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_get_symbol_for is_a_git_repo\
    )"

    # on filesystem
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_repo_has_stashes:-}"\
        "$(lf_prompt_alexis_get_symbol_for has_stashes)"\
      )"

    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}${Red:-""}"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_workspace_has_untracked:-}"\
        "$(lf_prompt_alexis_get_symbol_for has_untracked)"\
      )"

    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_workspace_has_modifications:-}" \
        "$(lf_prompt_alexis_get_symbol_for has_workspace_mods)"
      )"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_workspace_has_deletions:-}" \
        "$(lf_prompt_alexis_get_symbol_for has_workspace_dels)"\
      )"

    l_prompt_alexis_git_line="${l_prompt_alexis_git_line} ${White:-}${On_Yellow:-}$(\
      lf_prompt_alexis_get_symbol_for separator\
      )${Black} "

    # in index
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_index_has_modifications:-}" \
        "$(lf_prompt_alexis_get_symbol_for has_index_mods)"\
      )"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_index_has_moves:-}" \
        "$(lf_prompt_alexis_get_symbol_for has_index_moves)"\
      )"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_index_has_additions:-}" \
        "$(lf_prompt_alexis_get_symbol_for has_index_adds)"\
      )"
    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_index_has_deletions:-}" \
        "$(lf_prompt_alexis_get_symbol_for has_index_dels)"\
      )"

    # Operation
    # TODO

    l_prompt_alexis_git_line="${l_prompt_alexis_git_line} ${Yellow:-}${On_Red:-}$(
      lf_prompt_alexis_get_symbol_for separator
      )${White} "

    # Remote
    if [ "${gbg_head_is_detached:-}" = "true" ] # Detached state
    then
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(lf_prompt_alexis_get_symbol_for detached)"
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line} ${gbg_head_hash:-:0:7}"
    elif [ "${gbg_upstream_has_upstream:-}" = "false" ] # No upstream set
    then
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line}-- "
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(lf_prompt_alexis_get_symbol_for not_tracked)"
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line} --"
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line} (${gbg_head_branch:-"???"}) "
    else # Standard branch
      if [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
        l_prompt_alexis_git_line="${l_prompt_alexis_git_line} -${gbg_upstream_commits_behind_num} "
      else
        l_prompt_alexis_git_line="${l_prompt_alexis_git_line} -- "
      fi

      if [ "${gbg_upstream_has_diverged:-}" = "true" ]
      then
        upstream_diff="$(lf_prompt_alexis_get_symbol_for has_diverged)"
      elif [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
        upstream_diff="$(lf_prompt_alexis_get_symbol_for can_ff)"
      elif [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
        upstream_diff="$(lf_prompt_alexis_get_symbol_for should_push)"
      elif [ "${gbg_upstream_commits_ahead_num:-0}" -eq 0 ] && [ "${gbg_upstream_commits_behind_num:-0}" -eq 0 ]; then
        upstream_diff=" "
      fi
      l_prompt_alexis_git_line="${l_prompt_alexis_git_line}${upstream_diff}"
      unset upstream_diff

      if [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
        l_prompt_alexis_git_line="${l_prompt_alexis_git_line} +${gbg_upstream_commits_ahead_num} "
      else
        l_prompt_alexis_git_line="${l_prompt_alexis_git_line} -- "
      fi

      l_prompt_alexis_git_line="${l_prompt_alexis_git_line} (${gbg_head_branch} $(\
        lf_prompt_alexis_get_symbol_for "${gbg_upstream_merge_type:-merge}_tracking"\
        ) $(echo ${gbg_upstream_name:-""} | sed "s#$gbg_head_branch#...#")) "
    fi

    l_prompt_alexis_git_line="${l_prompt_alexis_git_line}$(\
      lf_prompt_alexis_enrich_append \
        "${gbg_head_is_on_tag:-}"\
        "$(lf_prompt_alexis_get_symbol_for tag) ${gbg_head_tag:-}"\
      )"

    l_prompt_alexis_git_line="${l_prompt_alexis_git_line} ${Red}${On_Default:-}$(\
      lf_prompt_alexis_get_symbol_for separator\
    )${ColorReset:-}"

    echo "${l_prompt_alexis_git_line}"
    unset l_prompt_alexis_git_line
    return 0
  else
    return 1
  fi
}

f_prompt_alexis_build_prompt() {
  # Format the git line
  f_prompt_alexis_git_line

  # Format separating line
  f_prompt_alexis_separating_line

  # Format user/host info
  f_prompt_alexis_host_info

  # Format PWD.
  f_prompt_alexis_pwd

  # Format last command status
  f_prompt_alexis_last_command_status
}

f_prompt_alexis_print_prompt() {
  printf "%b" "${v_prompt_alexis_separating_line}" 2>"${v_prompt_alexis_log_file:-/dev/null}"
  printf "%b" "${v_prompt_alexis_git_line}" 2>"${v_prompt_alexis_log_file}"
  printf "%b" "${v_prompt_alexis_host_info}" 2>"${v_prompt_alexis_log_file}"
  printf "%b" "${v_prompt_alexis_pwd}" 2>"${v_prompt_alexis_log_file}"
  printf "%b" "${v_prompt_alexis_last_command_status}" 2>"${v_prompt_alexis_log_file}"
}
