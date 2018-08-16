#! /bin/sh

f_sterope_posix_host_info() {
    # Do not rely on any shell expansion
    v_sterope_host_info="$(whoami)@$(hostname | cut -d'.' -f1) "
    export v_sterope_host_info
}

