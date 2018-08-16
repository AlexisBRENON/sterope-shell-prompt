#! /bin/sh

# shellcheck source=./lib/posix/init.sh
. "${STEROPE_ROOT}/lib/posix/init.sh"

current_shell=$(get_current_shell)
shell_lib="${STEROPE_ROOT}/lib/${current_shell}/init.sh"
if [ -e "${shell_lib}" ]; then
    # shellcheck source=./lib/bash/init.sh
    # shellcheck source=./lib/zsh/init.sh
    . "${shell_lib}"
else
    WARN "Sterope is not implemented yet for ${current_shell} shell"
fi

