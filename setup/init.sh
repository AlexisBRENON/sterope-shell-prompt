#! /bin/sh

get_current_shell() {
    # We cannot rely on the SHELL value which is not updated when launching a different shell
    if [ -n "${BASH_VERSION:-}" ]; then
        echo 'bash'
    elif [ -n "${ZSH_VERSION:-}" ]; then
        echo 'zsh'
    fi
}

f_sterope_setup() {
    # shellcheck source=./setup/posix.sh
    . "${STEROPE_ROOT}/setup/posix.sh"
    f_sterope_posix_setup

    current_shell="$(get_current_shell)"
    if [ -e "${STEROPE_ROOT}/setup/${current_shell}.sh" ]; then
        # shellcheck source=./setup/bash.sh
        # shellcheck source=./setup/zsh.sh
        . "${STEROPE_ROOT}/setup/${current_shell}.sh"
        eval "f_sterope_${current_shell}_setup"
    fi
    unset current_shell
}

