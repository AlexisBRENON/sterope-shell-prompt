#! /usr/bin/env sh

oneTimeSetUp() {
    # shellcheck disable=1090
    . "${GBG_DIR}/god_bless_git.sh"
    . ./sterope_prompt
    SHUNIT_CMDOUTFILE="${STEROPE_ROOT:-.}/tests/out.txt"
    export SHUNIT_CMDOUTFILE
    echo "" > "${SHUNIT_CMDOUTFILE}"

    SHUNIT_CMDERRFILE="${STEROPE_ROOT:-.}/tests/err.txt"
    export SHUNIT_CMDERRFILE
    echo "" > "${SHUNIT_CMDERRFILE}"

    . ./tests/util/utils.sh
}

setUp() {
    cd "${SHUNIT_TMPDIR}" || \
        fail "Unable to cd to tmpdir '${SHUNIT_TMPDIR}'"
    echo "## ${_shunit_test_:-Undefined test name}" \
        >> "${SHUNIT_CMDOUTFILE}"
    echo "## ${_shunit_test_}" \
        >> "${SHUNIT_CMDERRFILE}"
}

tearDown() {
    if [ -n "${SHUNIT_TMPDIR}" ]; then
        cd / || exit 250
        rm -fr "${SHUNIT_TMPDIR}"
        mkdir "${SHUNIT_TMPDIR}"
        cd "${SHUNIT_TMPDIR}" || exit 250
    fi
}

