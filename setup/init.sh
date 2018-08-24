#! /bin/sh

f_sterope_setup() {
    # shellcheck source=./setup/posix.sh
    . "${STEROPE_ROOT}/setup/posix.sh"
    f_sterope_posix_setup

    current_shell="$(f_sterope_get_current_shell)"
    if [ -e "${STEROPE_ROOT}/setup/${current_shell}.sh" ]; then
        # shellcheck source=./setup/bash.sh
        # shellcheck source=./setup/zsh.sh
        . "${STEROPE_ROOT}/setup/${current_shell}.sh"
        eval "f_sterope_${current_shell}_setup"
    fi
    unset current_shell
}

