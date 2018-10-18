#! /usr/bin/env bash

shell_lib="${STEROPE_ROOT}/lib/bash/"

# shellcheck source=./lib/bash/host_info.sh
. "${shell_lib}/host_info.sh"
# shellcheck source=./lib/bash/working_directory.sh
. "${shell_lib}/working_directory.sh"

f_sterope_bash_build_prompt() {
  export v_sterope_last_command_status="$?"
  f_sterope_posix_build_prompt
  PS1="$(f_sterope_print_prompt)"
}

