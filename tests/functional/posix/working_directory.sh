#! /bin/sh

. "./tests/util/setups.sh"

test_posix_working_directory() {
    f_sterope_posix_working_directory
    assertNotNull \
        "No variable defined for working directory" \
        "${v_sterope_working_directory:-}"
}

test_posix_wd_below_home() {
    cd "${HOME}" || exit 1
    f_sterope_posix_working_directory
    has_home_shortcut="$(\
        echo "${v_sterope_working_directory}" | \
        grep -e '~')"
    assertNotNull \
        "No home shortcut found in '${v_sterope_working_directory}'" \
        "${has_home_shortcut}"
    cd - || exit 1
}

test_posix_wd_above_home() {
    f_sterope_posix_working_directory
    has_home_shortcut="$(\
        echo "${v_sterope_working_directory}" | \
        grep -e '~')"
    assertNull \
        "Home shortcut found in '${v_sterope_working_directory}'" \
        "${has_home_shortcut}"
    cd - || exit 1
}

SHUNIT_PARENT=$0
. "./tests/shunit2/shunit2"

