#! /bin/sh

. "./tests/util/setups.sh"

test_posix_not_git() {
    f_sterope_posix_git
    assertNull \
        "Git stripe not empty in a non git repo" \
        "${v_sterope_git:-}"
}

test_posix_git() {
    git init .
    f_sterope_posix_git
    assertNotNull \
        "Git stripe empty in a git repo" \
        "${v_sterope_git}"
}

SHUNIT_PARENT=$0
. "./tests/shunit2/shunit2"

