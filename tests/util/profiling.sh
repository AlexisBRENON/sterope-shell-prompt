#! /usr/bin/env sh

. "./tests/util/setups.sh"

_profile() {
    PROFILE_DIR="$(mktemp -d)"

    mkfifo "${PROFILE_DIR}/debug_tee" "${PROFILE_DIR}/tee_sed"
    exec 4<>"${PROFILE_DIR}/debug_tee"
    exec 5<>"${PROFILE_DIR}/tee_sed"
    tee "${PROFILE_DIR}/cmd.txt" <&4 >&5 &
    tee_pid=$!
    sed -u 's/^.*$/now/' <&5 | \
        date -f - +%s.%N \
        > "${PROFILE_DIR}/time.txt" &
    date_pid=$!
    exec 3>&2 2>&4

    set -x
    "$@"
    set +x

    # Fill date buffer
    num_cmd="$(wc -l "${PROFILE_DIR}/cmd.txt" | cut -d' ' -f1)"
    while [ \
        "$(\
            wc -l "${PROFILE_DIR}/time.txt" | \
            cut -d' ' -f1)" \
        -lt "${num_cmd}" ]; do
        echo "" >&5
    done

    exec 2>&3 3>&-

    kill ${date_pid} ${tee_pid}

    exec 4>&- 5>&- 4<&- 5<&-
    rm "${PROFILE_DIR}/debug_tee" "${PROFILE_DIR}/tee_sed"

    while read -r tim ; do
        if [ -z "$last" ] ; then
            last="${tim}"
            first="${tim}"
        fi
        crt="$(\
            echo "${tim} - ${last}" | bc)"
        tot="$(\
            echo "${tim} - ${first}" | bc)"
        LC_ALL=C printf "%3.9f\\t%3.9f\\n" "${tot}" "${crt}"
        last=${tim}
    done < "${PROFILE_DIR}/time.txt" > "${PROFILE_DIR}/acc_time.txt"

    profiling="$(\
        head -n "${num_cmd}" "${PROFILE_DIR}/acc_time.txt" | \
        paste - "${PROFILE_DIR}/cmd.txt"\
        )"

    rm -r "${PROFILE_DIR}"

    echo "${profiling}"
}

_total_time() {
    echo "${1}" | tail -n 1 | cut -f1
}

_longest_command() {
    echo "${1}" | cut -f2-3 | sort -rn | head -n1 | sed 's/\t+* /\t/'
}

_sumup_profile() {
    longest_command_time="$(echo "${2}" | cut -f1)"
    longest_command="$(echo "${2}" | cut -f2)"
    echo "  Total time: ${1} s"
    echo "  longest command: ${longest_command} (took ${longest_command_time})"
}

