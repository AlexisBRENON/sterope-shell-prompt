#! /usr/bin/env sh

. "./tests/util/setups.sh"

test_invokation() {
    invokation_output=$("${STEROPE_ROOT}/sterope_prompt")
    invokation_exit=$?
    assertEquals \
        "Invokation exits with error" \
        0 ${invokation_exit}

    expected_version=${STEROPE_VERSION:-undefined}
    echo "${invokation_output}" | grep -q "${expected_version}"
    assertTrue \
        "Version number '${expected_version}' not found in \\n-----\\n${invokation_output}-----\\n" \
        $?
}

SHUNIT_PARENT=$0
. "./tests/shunit2/shunit2"

