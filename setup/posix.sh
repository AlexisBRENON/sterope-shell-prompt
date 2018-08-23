#! /bin/sh

f_sterope_posix_setup() {
    v_sterope_cache_dir="${XDG_CACHE_DIR:-${HOME}/.cache}/sterope"
    v_sterope_config_dir="${XDG_CONFIG_DIR:-${HOME}/.config}/sterope"

    mkdir -p "${v_sterope_cache_dir}"
    mkdir -p "${v_sterope_config_dir}"

    STEROPE_CACHE="${v_sterope_cache_dir}"
    STEROPE_ERR_FILE="${STEROPE_CACHE}/error.log"
    STEROPE_LOG_FILE="${STEROPE_CACHE}/output.log"
    echo "" > "${STEROPE_LOG_FILE}" 2> "${STEROPE_ERR_FILE}"

    v_sterope_git_symbols="$(lf_sterope_get_git_symbols)\\n"
    v_sterope_py_symbols="$(lf_sterope_get_py_symbols)\\n"
    v_sterope_help_message="$(lf_sterope_get_help_message)\\n"

    info "$(printf '%s' "${v_sterope_git_symbols}" | tr '\036' ',')" #| sed -e 's/:\(.*\)/:'"'"'\1'"'"'/'
    info "${v_sterope_py_symbols}" # | sed -e 's/:\(.*\)/:'"'"'\1'"'"'/'
    info "${v_sterope_help_message}"
}

lf_sterope_get_git_symbols() {
    if [ -e "$HOME/.local/share/icons-in-terminal/icons_bash.sh" ]; then
        debug "Loading icons in terminal"
        #shellcheck disable=1090
        . "$HOME/.local/share/icons-in-terminal/icons_bash.sh"
    else
        warning "Sterope prompt heavily relies on icons-in-terminal"
        warning "Please see https://github.com/sebastiencs/icons-in-terminal/"
    fi
    l_sterope_tmp=""
    for l_sterope_symbol in \
        "is_a_git_repo:${oct_octoface:-git}    " \
        "separator:${powerline_left_hard_divider:-▓▒░} " \
        "has_stashes:${fa_asterisk:-stash} " \
        "has_untracked:${fa_eye_slash:-untracked} " \
        "has_conflicts:\\u1F4A5 " \
        "has_pending_action:\\u1F527 " \
        "has_workspace_mods:${fa_pencil:-M} " \
        "has_workspace_dels:${fa_minus:-D} " \
        "has_index_mods:${fa_pencil:-M} " \
        "has_index_moves:${fa_mail_reply:-V} " \
        "has_index_adds:${fa_plus:-A} " \
        "has_index_dels:${fa_minus:-D} " \
        "ready_to_commit:${oct_git_commit:-\\u1F3C1} " \
        "detached:${fa_chain_broken:-detached} " \
        "not_tracked:${md_cloud_off:-not tracked} " \
        "has_diverged:${oct_repo_forked:-Y} " \
        "can_ff:${md_fast_forward:-">>"} " \
        "should_push:${oct_cloud_upload:-"->"} " \
        "tag:${fa_tag:-tag} "; do
        l_sterope_tmp="$(\
            printf '%s%s\036' \
            "${l_sterope_tmp}" \
            "${l_sterope_symbol}")"
    done
    printf '%s' "${l_sterope_tmp}"
    unset l_sterope_tmp l_sterope_symbol
}

lf_sterope_get_py_symbols() {
    if [ -e "$HOME/.local/share/icons-in-terminal/icons_bash.sh" ]; then
        debug "Loading icons in terminal"
        #shellcheck disable=1090
        . "$HOME/.local/share/icons-in-terminal/icons_bash.sh"
    else
        warning "Sterope prompt heavily relies on icons-in-terminal"
        warning "Please see https://github.com/sebastiencs/icons-in-terminal/"
    fi

    l_sterope_tmp=""
    for l_sterope_symbol in \
        "is_a_virtualenv:${dev_python:-py}    " \
        "separator:${powerline_left_hard_divider:-▓▒░} " \
        ; do
        l_sterope_tmp="$(\
            printf '%s%s\036' \
            "${l_sterope_tmp}" \
            "${l_sterope_symbol}")"
    done
    printf '%s' "${l_sterope_tmp}"
    unset l_sterope_tmp l_sterope_symbol
}

lf_sterope_get_help_message() {
    cat << EOM
Sterope is a multiline prompt which display:
  * an empty line to separate one command from another;
  * a git line if you are in a git repository;
  * a virtualenv python line in a VirtualEnv;
  * the host and working directory line (as classical prompts);
  * an indicator of the exit status of the last command.

The git line is based on the god-bless-git plugin (github.com/AlexisBRENON/god-bless-git) and is similar to the oh-my-git project. It's a colorful line with plenty informations.
EOM
}

