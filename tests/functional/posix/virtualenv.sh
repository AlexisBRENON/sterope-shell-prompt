#! /bin/sh

. "./tests/util/setups.sh"

test_posix_not_virtualenv() {
    f_sterope_posix_virtualenv
    assertNull \
        "Virtualenv stripe not empty without VE activated" \
        "${v_sterope_virtualenv:-}"
}

echo "args: $*"
test_posix_virtualenv() {
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

