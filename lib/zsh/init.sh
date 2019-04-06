#! /usr/bin/env bash

shell_lib="${STEROPE_ROOT}/lib/zsh/"

# shellcheck source=./lib/zsh/git.sh
. "${shell_lib}/git.sh"
# shellcheck source=./lib/zsh/host_info.sh
. "${shell_lib}/host_info.sh"
# shellcheck source=./lib/zsh/working_directory.sh
. "${shell_lib}/working_directory.sh"
# shellcheck source=./lib/zsh/exit_status.sh
. "${shell_lib}/exit_status.sh"

f_sterope_zsh_build_prompt() {
  export v_sterope_last_command_status="$?"
  # Format the git line
  f_sterope_zsh_git

  # Format user/host info
  f_sterope_zsh_host_info

  # Format PWD.
  f_sterope_zsh_working_directory

  # Format last command status
  f_sterope_zsh_exit_status
}

