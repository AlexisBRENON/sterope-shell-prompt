#! /usr/bin/env bash

shell_lib="${STEROPE_ROOT}/lib/bash/"

# shellcheck source=./lib/bash/host_info.sh
. "${shell_lib}/host_info.sh"
# shellcheck source=./lib/bash/working_directory.sh
. "${shell_lib}/working_directory.sh"

f_sterope_bash_build_prompt() {
    export v_sterope_last_command_status="$?"
    # Format the git line
    f_sterope_git

    # Format the Python line
    f_sterope_virtualenv

    # Format separating line
    f_sterope_separating_line

    # Format user/host info
    f_sterope_host_info

    # Format PWD.
    f_sterope_working_directory

    # Format last command status
    f_sterope_exit_status

    PS1="$(f_sterope_print_prompt)"
}

