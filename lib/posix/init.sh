#! /bin/sh

posix_lib="${STEROPE_ROOT}/lib/posix/"

# shellcheck source=./lib/posix/separating_line.sh
. "${posix_lib}/separating_line.sh"
# shellcheck source=./lib/posix/host_info.sh
. "${posix_lib}/host_info.sh"
# shellcheck source=./lib/posix/working_directory.sh
. "${posix_lib}/working_directory.sh"
# shellcheck source=./lib/posix/exit_status.sh
. "${posix_lib}/exit_status.sh"
# shellcheck source=./lib/posix/virtualenv.sh
. "${posix_lib}/virtualenv.sh"
# shellcheck source=./lib/posix/git.sh
. "${posix_lib}/git.sh"

lf_prompt_alexis_get_py_symbol_for() {
    symbol_id=${1:-}
    symbol_idx=$(echo "${v_prompt_alexis_py_symbols_map:-}" | grep "${symbol_id}:" | head -1 | cut -d':' -f2)
    echo "${v_prompt_alexis_py_symbols:-}" | cut -d":" -f "${symbol_idx}"
}


lf_prompt_alexis_get_symbol_for() {
    symbol_id=${1:-}
    symbol_idx=$(echo "${v_prompt_alexis_git_symbols_map:-}" | grep "${symbol_id}:" | head -1 | cut -d':' -f2)
    echo "${v_prompt_alexis_git_symbols:-}" | cut -d":" -f "${symbol_idx}"
}

f_posix_build_prompt() {
    # Format the git line
    f_sterope_posix_git

    # Format the Python line
    f_sterope_posix_virtualenv

    # Format separating line
    f_sterope_posix_separating_line

    # Format user/host info
    f_sterope_posix_host_info

    # Format PWD.
    f_sterope_posix_working_directory

    # Format last command status
    f_sterope_posix_exit_status
}

f_prompt_alexis_print_prompt() {
    printf \
        "%b" \
        "${v_sterope_separating_line:-}" \
        2>"${v_sterope_log_file:-/dev/null}"
    printf "%b" "${v_sterope_git:-}" 2>"${v_sterope_log_file}"
    printf "%b" "${v_sterope_virtualenv:-}" 2>"${v_sterope_log_file}"
    printf "%b" "${v_sterope_host_info:-}" 2>"${v_sterope_log_file}"
    printf "%b" "${v_sterope_working_directory:-}" 2>"${v_sterope_log_file}"
    printf "%b" "${v_sterope_exit_status:-}" 2>"${v_sterope_log_file}"
}
