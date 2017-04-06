#! /usr/bin/env bash

f_prompt_alexis_bash_build_prompt() {
  export v_prompt_alexis_last_command_status="$?"
  f_prompt_alexis_build_prompt
  PS1="$(f_prompt_alexis_print_prompt)"
}

unset f_prompt_alexis_host_info
f_prompt_alexis_host_info() {
  export v_prompt_alexis_host_info="\u@\h "
}

unset f_prompt_alexis_pwd
f_prompt_alexis_pwd() {
  export v_prompt_alexis_pwd="${Green:-}\w${ColorReset:-}\n"
}

