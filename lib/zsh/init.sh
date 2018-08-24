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
  export v_sterope_last_exit_status="$?"
  f_sterope_build_prompt
}

