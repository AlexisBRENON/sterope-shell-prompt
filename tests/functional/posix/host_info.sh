#! /bin/sh

. "./tests/util/setups.sh"

test_posix_host_info() {
    f_sterope_host_info
    assertNotNull \
        "No output defined for host info" \
        "${v_sterope_host_info:-}"
}

SHUNIT_PARENT=$0
. "./tests/shunit2/shunit2"

