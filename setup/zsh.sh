#! /usr/bin/env zsh

function f_sterope_zsh_setup {
  prompt_opts=(cr percent subst)

  v_sterope_no_async="false"

  # Load required functions.
  autoload -Uz add-zsh-hook
  # Build the prompt on precmd hook
  add-zsh-hook precmd sterope_zsh_build_prompt

  # Just print the prompt (do not build it)
  PROMPT='${$(f_sterope_print_prompt)}${editor_info[keymap]}'
  RPROMPT='${$(f_sterope_print_rprompt)}'

  export v_sterope_no_async
  # Where async data are stored for callback
  export v_sterope_async_git_data="/tmp/prompt_alexis-${USER}-git"
  export v_sterope_help_message
}

