#! /usr/bin/env zsh

function prompt_alexis_zsh_build_prompt() {
  export _prompt_alexis_last_command_return_code="$?"
  f_prompt_alexis_build_prompt
}

# ###################################################################
# Use an async process to fetch git infos
# ###################################################################

if [ "${v_prompt_alexis_no_async:-false}" = "false" ]; then

  unset f_prompt_alexis_git_line
  f_prompt_alexis_git_line() {
    # Kill the old git_info process if it is still running.
    v_prompt_alexis_async_git_pid="$(cat "${XDG_CACHE_DIR:-${HOME}/.cache}/prompt_alexis/git_pid")" 2> /dev/null
    if [ "${v_prompt_alexis_async_git_pid:-0}" -gt 0 ]; then
      kill -SIGKILL "${v_prompt_alexis_async_git_pid}" > /dev/null 2>&1
    fi

    trap f_prompt_alexis_zsh_async_build_git_line USR1 # Call the formatter function when info will be retrieved
    f_prompt_alexis_zsh_async_git_line &! # Retrieve info asynchronously
    # Keep track of the asynchronous process
    echo "$!" > "${XDG_CACHE_DIR:-${HOME}/.cache}/prompt_alexis/git_pid"
    f_prompt_alexis_async_timeout &!
  }

  f_prompt_alexis_zsh_async_git_line() {
    # Get Git repository information.
    if [ "$(set | grep -c "god_bless_git")" -eq 1 ]; then
      god_bless_git
      export -p | grep -Ee "gbg_" | rev | cut -d' ' -f1 | rev >! "${v_prompt_alexis_async_git_data}"
    fi

    # Signal completion to parent process.
    kill -SIGUSR1 $$
  }

  f_prompt_alexis_async_timeout () {
    sleep 5
    l_prompt_alexis_async_git_pid="$(cat "${XDG_CACHE_DIR:-${HOME}/.cache}/prompt_alexis/git_pid")" 2> /dev/null
    if [ "${l_prompt_alexis_async_git_pid}" -gt 0 ]; then
      kill -SIGKILL "${l_prompt_alexis_async_git_pid}" > /dev/null 2>&1
      echo "0" > "${XDG_CACHE_DIR:-${HOME}/.cache}/prompt_alexis/git_pid"
    fi
  }


  f_prompt_alexis_zsh_async_build_git_line() {
    v_prompt_alexis_async_git_pid="$(cat "${XDG_CACHE_DIR:-${HOME}/.cache}/prompt_alexis/git_pid")" 2> /dev/null
    if [ "${v_prompt_alexis_async_git_pid:-0}" -gt 0 ] && \
      [ -e "${v_prompt_alexis_async_git_data}" ]; then
      . "${v_prompt_alexis_async_git_data}" # Load gbg variables
      l_prompt_alexis_new_git_line="$(f_prompt_alexis_build_git_line)" # Generate the pretty line
      if [ -n "${l_prompt_alexis_new_git_line}" ]
      then
        l_prompt_alexis_new_git_line="${l_prompt_alexis_new_git_line}\n"
      fi
      # If line has changed
      if [ "${l_prompt_alexis_new_git_line}" != "${v_prompt_alexis_git_line}" ]; then
        export v_prompt_alexis_git_line="${l_prompt_alexis_new_git_line}"
        zle && zle reset-prompt && print '' # Refresh the prompt
      fi
      unset l_prompt_alexis_new_git_line

      # Reset async states.
      echo "0" > "${XDG_CACHE_DIR:-${HOME}/.cache}/prompt_alexis/git_pid"
      rm -f "${v_prompt_alexis_async_git_data}"
    fi
  }
fi


unset f_prompt_alexis_host_info
f_prompt_alexis_host_info() {
  export v_prompt_alexis_host_info="%n@%m "
}

unset f_prompt_alexis_pwd
f_prompt_alexis_pwd() {
  export v_prompt_alexis_pwd="%{%F{green}%}%~%{%f%}\n"
}

unset f_prompt_alexis_last_command_status
f_prompt_alexis_last_command_status() {
  if [ -n "${ColorFontCode:-}" ]; then
    _yellow="${ColorFontCode}226${ColorEndCode}"
    _brown="${ColorFontCode}94${ColorEndCode}"
  fi
  sparkles='\u2728'
  poo='💩'
  export v_prompt_alexis_last_command_status="%{%(?.${_yellow}${sparkles}.${_brown}${poo})%G%} %{%f%} "
}

