#! /bin/sh

f_prompt_alexis_posix_setup() {
  # Load utilities functions
  . "${PROMPT_ALEXIS_PATH}/functions/posix.sh"
  if [ -z "${v_prompt_alexis_git_symbols:-""}" ]; then
    if [ -e "$HOME/.local/share/icons-in-terminal/icons_bash.sh" ]; then
      DEBUG "Loading icons in terminal"
      . "$HOME/.local/share/icons-in-terminal/icons_bash.sh"
      v_tmp=" ${oct_octoface:-"octoface"}    " # is_a_git_repo
      v_tmp="$v_tmp:${powerline_left_hard_divider:-"left divider"} " # separator
      v_tmp="$v_tmp: : : "
      v_tmp="$v_tmp:${fa_asterisk:-"asterisk"} :${fa_eye_slash:-"eye_slash"} "
      v_tmp="$v_tmp: : : "
      v_tmp="$v_tmp:${fa_pencil:-pencil} :${fa_minus:-"minus"} : : "
      v_tmp="$v_tmp: "
      v_tmp="$v_tmp:${fa_pencil} :${fa_mail_reply:-"mail_reply"} :✨ :🔥 : "
      v_tmp="$v_tmp:${oct_git_commit:-"commit"} :${fa_wrench:-"wrench"} : : : "
      v_tmp="$v_tmp:${fa_chain_broken:-"chain_broken"} :${md_cloud_off:-"cloud_off"} : : : "
      v_tmp="$v_tmp:${oct_repo_forked:-repo_forked} :${md_fast_forward:-fast_forward} :${oct_cloud_upload:-cloud_upload} : : "
      v_tmp="$v_tmp:${oct_git_pull_request:-pull_request} :${oct_git_merge:-merge} : : : "
      v_tmp="$v_tmp:${fa_tag:-tag} "
      v_prompt_alexis_git_symbols="${v_tmp}"
      unset v_tmp
    else
      echo "prompt_alexis: Git status line rely on icons-in-terminal project for nice icons." >&2
      echo "Please see https://github.com/sebastiencs/icons-in-terminal/." >&2
      v_prompt_alexis_git_symbols=""
    fi
  fi
  DEBUG "git_symbols: ${v_prompt_alexis_git_symbols}"
  v_prompt_alexis_git_symbols_map="
    is_a_git_repo:1
    separator:2
    has_stashes:6
    has_untracked:7
    has_workspace_mods:11
    has_workspace_dels:12
    has_index_mods:16
    has_index_moves:17
    has_index_adds:18
    has_index_dels:19
    ready_to_commit:21
    has_pending_action:22
    detached:26
    not_tracked:27
    has_diverged:31
    can_ff:32
    should_push:33
    rebase_tracking:36
    merge_tracking:37
    tag:41"


  v_prompt_alexis_help_string="alexis prompt is a multiline prompt which display:
  * an empty line to separate one command from another;
  * a git line if you are in a git repository (see below);
  * the host and working directory line (as classical prompts);
  * an indicator of the exit status of the last command.

The git line is based on the god-bless-git plugin (github.com/AlexisBRENON/god-bless-git) and is similar to the oh-my-git project. It's a colorful line with plenty informations.

List of the prompt options:
  -s <symbols>
    A colon separated string representing symbols to use in the git line.
    Default: 
      \"${v_prompt_alexis_git_symbols}\"
    Symbols meanings are:
      1: Current directory is a git repository
      2: In-line separator
      6: Has stashes
      7: Has untracked files
      11: Workspace is modified
      12: Workspace has deleted files
      16: Index has modified files
      17: Index has moved files
      18: Index has new files
      19: Index has deleted files
      21: The repo is ready to commit (all in the index)
      22: An operation (merge, rebase) is pending
      26: HEAD is detached
      27: Current branch as no upstream
      31: Local and upstream have diverged
      32: A fast-forward merge is possible
      33: Your local branch is ahead of the upstream
      36: Pull will rebase
      37: Pull will merge
      41: HEAD is tagged"

  l_prompt_alexis_old_optind=${OPTIND}
  while getopts s: OPTION; do
    case ${OPTION} in
      s)
        v_prompt_alexis_git_symbols="${OPTARG}"
        ;;
    esac
  done
  OPTIND=${l_prompt_alexis_old_optind}
  unset l_prompt_alexis_old_optind

  export v_prompt_alexis_git_symbols
  export v_prompt_alexis_git_symbols_map
  export v_prompt_alexis_help_string
  export v_prompt_alexis_log_file="/tmp/prompt_alexis_${USER}_log"
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

