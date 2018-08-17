#! /bin/sh

lf_sterope_posix_get_symbol() {
    l_sterope_symbols="$1"
    l_sterope_field="$2"
    printf '%s' "${l_sterope_symbols}" | \
        tr '\\u001e' '\\n' | \
        grep "^${l_sterope_field}:" | \
        sed -e 's/^'"${l_sterope_field}"':\(.*\)/\1/'
    unset l_sterope_symbols l_sterope_field
}

