#! /bin/sh

f_sterope_posix_exit_status() {
    l_sterope_color_yellow=""
    l_sterope_color_brown=""
    if [ -n "${ColorFontCode:-}" ] && [ -n "${ColorEndCode:-}" ]; then
        l_sterope_color_yellow="${ColorFontCode}226${ColorEndCode}"
        l_sterope_color_brown="${ColorFontCode}94${ColorEndCode}"
    fi
    if [ "${v_sterope_last_exit_status:-1}" -eq 0 ]; then
        v_sterope_exit_status="${l_sterope_color_yellow}✨"
    else
        v_sterope_exit_status="${l_sterope_color_brown}💩"
    fi
    v_sterope_exit_status="${v_sterope_exit_status} ${ColorReset:-} "
    export v_sterope_exit_status
}

