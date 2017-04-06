#! /usr/bin/env zsh

function f_prompt_alexis_zsh_setup {
  . "${PROMPT_ALEXIS_PATH}/functions/zsh.sh"
  prompt_opts=(cr percent subst)

  v_prompt_alexis_no_async="false"
  l_prompt_alexis_old_optind=${OPTIND}
  while getopts n OPTION; do
    case ${OPTION} in
      n)
        v_prompt_alexis_no_async="true"
        ;;
    esac
  done
  OPTIND=${l_prompt_alexis_old_optind}
  unset l_prompt_alexis_old_optind

  v_prompt_alexis_help_string="${v_prompt_alexis_help_string}
  -n
    Do not use the async feature for git info line."

  # Load required functions.
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd prompt_alexis_zsh_build_prompt

  PROMPT='${$(f_prompt_alexis_print_prompt)}${editor_info[keymap]}'
  RPROMPT=''

  export v_prompt_alexis_no_async
  export v_prompt_alexis_async_git_data="/tmp/prompt_alexis-${USER}-git"
  export v_prompt_alexis_help_string
}

# TODO move it to a posix version
function f_prompt_alexis_zsh_preview {
  prompt_preview_safely 'alexis'
}

