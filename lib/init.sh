#! /bin/sh

# shellcheck source=./lib/posix/init.sh
. "${STEROPE_ROOT}/lib/posix/init.sh"

f_sterope_define_aliases "posix"

current_shell=$(f_sterope_get_current_shell)
if [ -n "${current_shell}" ]; then
    shell_lib="${STEROPE_ROOT}/lib/${current_shell}/init.sh"
    if [ -e "${shell_lib}" ]; then
        # shellcheck source=./lib/bash/init.sh
        # shellcheck source=./lib/zsh/init.sh
        . "${shell_lib}"
        f_sterope_define_aliases "${current_shell}"
    else
        WARN "Sterope is not implemented yet for ${current_shell} shell"
    fi
fi

