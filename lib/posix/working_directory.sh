#! /bin/sh

f_sterope_posix_working_directory() {
    v_sterope_working_directory="${Green:-}$(\
        echo "${PWD}" | \
        sed "s#^${HOME}#~#"\
        )${ColorReset:-}\\n"
    export v_sterope_working_directory
}

