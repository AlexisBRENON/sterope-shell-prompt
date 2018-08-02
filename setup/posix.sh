#! /bin/sh

f_sterope_posix_setup() {
    v_sterope_cache_dir="${XDG_CACHE_DIR:-${HOME}/.cache}/sterope"
    v_sterope_config_dir="${XDG_CONFIG_DIR:-${HOME}/.config}/sterope"

    mkdir -p "${v_sterope_cache_dir}"
    mkdir -p "${v_sterope_config_dir}"

    v_sterope_git_symbols="$(lf_sterope_get_git_symbols)\\n"
    v_sterope_py_symbols="$(lf_sterope_get_py_symbols)\\n"
    v_sterope_help_message="$(lf_sterope_get_help_message)\\n"

    printf '%s' "${v_sterope_git_symbols}" #| sed -e 's/:\(.*\)/:'"'"'\1'"'"'/'
    printf '%s' "${v_sterope_py_symbols}" # | sed -e 's/:\(.*\)/:'"'"'\1'"'"'/'
    printf '%s' "${v_sterope_help_message}"
}

lf_sterope_get_git_symbols() {
    v_tmp=""
    if [ -e "$HOME/.local/share/icons-in-terminal/icons_bash.sh" ]; then
        DEBUG "Loading icons in terminal"
        #shellcheck disable=1090
        . "$HOME/.local/share/icons-in-terminal/icons_bash.sh"
    else
        WARN "Sterope prompt heavily relies on icons-in-terminal"
        WARN "Please see https://github.com/sebastiencs/icons-in-terminal/"
    fi
    v_tmp="is_a_git_repo:${oct_octoface:-git}    \\n"
    v_tmp="${v_tmp}separator:${powerline_left_hard_divider:-▓▒░} \\n"
    v_tmp="${v_tmp}has_stashes:${fa_asterisk:-stash} \\n"
    v_tmp="${v_tmp}has_untracked:${fa_eye_slash:-untracked} \\n"
    v_tmp="${v_tmp}has_conflicts:\\u1F4A5 \\n"  # Explosion
    v_tmp="${v_tmp}has_pending_action:\\u1F527 \\n"  # Wrench
    v_tmp="${v_tmp}has_workspace_mods:${fa_pencil:-M} \\n"
    v_tmp="${v_tmp}has_workspace_dels:${fa_minus:-D} \\n"
    v_tmp="${v_tmp}has_index_mods:${fa_pencil:-M} \\n"
    v_tmp="${v_tmp}has_index_moves:${fa_mail_reply:-V} \\n"
    v_tmp="${v_tmp}has_index_adds:${fa_plus:-A} \\n"
    v_tmp="${v_tmp}has_index_dels:${fa_minus:-D} \\n"
    v_tmp="${v_tmp}ready_to_commit:${oct_git_commit:-\\u1F3C1} \\n"
    v_tmp="${v_tmp}detached:${fa_chain_broken:-detached} \\n"
    v_tmp="${v_tmp}not_tracked:${md_cloud_off:-not tracked} \\n"
    v_tmp="${v_tmp}has_diverged:${oct_repo_forked:-Y} \\n"
    v_tmp="${v_tmp}can_ff:${md_fast_forward:-">>"} \\n"
    v_tmp="${v_tmp}should_push:${oct_cloud_upload:-"->"} \\n"
    v_tmp="${v_tmp}tag:${fa_tag:-tag} \\n"
    printf '%s' "${v_tmp}"
}

lf_sterope_get_py_symbols() {
    v_tmp=""
    if [ -e "$HOME/.local/share/icons-in-terminal/icons_bash.sh" ]; then
        DEBUG "Loading icons in terminal"
        #shellcheck disable=1090
        . "$HOME/.local/share/icons-in-terminal/icons_bash.sh"
    else
        WARN "Sterope prompt heavily relies on icons-in-terminal"
        WARN "Please see https://github.com/sebastiencs/icons-in-terminal/"
    fi

    v_tmp="is_a_virtualenv:${dev_python:-py}    \\n"
    v_tmp="${v_tmp}separator:${powerline_left_hard_divider:-▓▒░} \\n"
    printf '%s' "${v_tmp}"
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


f_prompt_alexis_posix_help() {
  echo "${v_prompt_alexis_help_string}"
}

f_prompt_alexis_posix_preview() {
  (
    f_prompt_alexis_posix_setup
    (
      echo 'alexis theme, not in a git repo, after a successful command:'
      v_prompt_alexis_git_line=""
      v_prompt_alexis_py_line=""
      f_prompt_alexis_separating_line
      f_prompt_alexis_host_info
      f_prompt_alexis_pwd
      v_prompt_alexis_last_command_status=0
      f_prompt_alexis_last_command_status
      f_prompt_alexis_print_prompt
      echo "command arg1 arg2 ... argn"
      echo ""
    )
    (
    echo 'alexis theme, in a git repo, after a failed command:'
    export gbg_is_a_git_repo='true'
    export gbg_repo_has_stashes='true'
    export gbg_workspace_deletions_num=1
    export gbg_workspace_has_deletions="true"
    export gbg_workspace_modifications_num=1
    export gbg_workspace_has_modifications="true"
    export gbg_workspace_has_untracked="true"
    export gbg_index_has_additions="true"
    export gbg_index_additions_num=1
    export gbg_upstream_commits_ahead_num=1
    export gbg_upstream_commits_has_ahead="true"
    export gbg_upstream_commits_behind_num=1
    export gbg_upstream_commits_has_behind="true"
    export gbg_upstream_has_diverged="true"
    export gbg_upstream_has_upstream="true"
    export gbg_upstream_name="origin/branchname"
    export gbg_head_branch="localbranchname"
    export gbg_head_hash="commit hash"
    export gbg_head_is_on_tag="true"
    export gbg_head_tag="tagname"
    v_prompt_alexis_git_line="$(f_prompt_alexis_build_git_line)"
    if [ -n "${v_prompt_alexis_git_line}" ]
    then
      v_prompt_alexis_git_line="${v_prompt_alexis_git_line}\n"
    fi
    f_prompt_alexis_separating_line
    f_prompt_alexis_host_info
    f_prompt_alexis_pwd
    v_prompt_alexis_last_command_status=1
    f_prompt_alexis_last_command_status
    f_prompt_alexis_print_prompt
    echo "command arg1 arg2 ... argn"
    echo ''
    )
  )
}

prompt_alexis_help() { f_prompt_alexis_posix_help "$@"; }
prompt_alexis_preview() { f_prompt_alexis_posix_preview "$@"; }

