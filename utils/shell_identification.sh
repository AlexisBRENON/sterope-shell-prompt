#! /bin/sh

f_sterope_get_current_shell() {
    # We cannot rely on the SHELL value which is not updated when launching a different shell
    if [ -n "${BASH_VERSION:-}" ]; then
        echo 'bash'
    elif [ -n "${ZSH_VERSION:-}" ]; then
        echo 'zsh'
    fi
}

get_current_shell() {
    warning "get_current_shell is deprecated.\\n  Use f_sterope_get_current_shell instead."
    f_sterope_get_current_shell
}



