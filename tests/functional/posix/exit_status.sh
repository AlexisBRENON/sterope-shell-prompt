#! /bin/sh

. "./tests/util/setups.sh"

test_posix_exit_status() {
    f_sterope_posix_exit_status
    assertNotNull \
        "No output defined for exit status" \
        "${v_sterope_exit_status:-}"
}

test_posix_exit_status_true() {
    unset v_sterope_last_command_status
    true
    f_sterope_build_prompt
    assertEquals \
        "Last exit status command not propagated." \
        0 "${v_sterope_last_command_status:-undefined}"
}

test_posix_exit_status_false() {
    unset v_sterope_last_command_status
    false
    f_sterope_build_prompt
    assertEquals \
        "Last exit status command not propagated." \
        1 "${v_sterope_last_command_status:-undefined}"
}

test_posix_isolated_exit_status_true() {
    unset v_sterope_last_command_status
    true
    f_sterope_exit_status
    assertEquals \
        "Last exit status command not propagated." \
        0 "${v_sterope_last_command_status:-undefined}"
}

test_posix_isolated_exit_status_false() {
    unset v_sterope_last_command_status
    false
    f_sterope_exit_status
    assertEquals \
        "Last exit status command not propagated." \
        1 "${v_sterope_last_command_status:-undefined}"
}


SHUNIT_PARENT=$0
. "./tests/shunit2/shunit2"

