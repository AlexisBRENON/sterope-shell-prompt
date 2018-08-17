#! /bin/sh

. "./tests/util/setups.sh"

test_git() {
    f_sterope_posix_git
    assertNull \
        "Git stripe not empty in a non git repo" \
        "${v_sterope_git:-}"

    git init .
    f_sterope_posix_git
    assertNotNull \
        "Git stripe empty in a git repo" \
        "${v_sterope_git}"
}

test_long_virtualenv() {
    f_sterope_posix_virtualenv
    assertNull \
        "Virtualenv stripe not empty without VE activated" \
        "${v_sterope_virtualenv:-}"

    if command -v virtualenv; then
        virtualenv venv
        # shellcheck disable=1091
        . ./venv/bin/activate
        assertNotNull \
            "Unable to activate virtualenv ?" \
            "${VIRTUAL_ENV:-}"
        f_sterope_posix_virtualenv
        assertNotNull \
            "Virtualenv stripe empty with VE activated" \
            "${v_sterope_virtualenv}"
    else
        warn "Virtualenv not available. Skip test"
    fi
}

SHUNIT_PARENT=$0
. "./tests/shunit2/shunit2"

