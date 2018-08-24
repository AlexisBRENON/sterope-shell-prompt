#! /bin/sh

# Define Sterope API function as aliases to shell specific functions.

f_sterope_define_aliase() {
    shell_name="$1"
    for token in "separating_line" \
        "host_info" \
        "working_directory" \
        "exit_status" \
        "virtualenv" \
        "git" \
        "build_prompt" \
        "print_prompt"; do
        if type "f_sterope_${shell_name}_${token}"; then
            # shellcheck disable=2139
            alias "f_sterope_${token}=f_sterope_${shell_name}_${token}"
        fi
    done
}

