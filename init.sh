#! /bin/sh

. "${PROMPT_ALEXIS_PATH}/functions.sh"

prompt_alexis_posix_setup() {
  export _prompt_alexis_git_symbols="   :: : : :  : : : : : :🔥 : : : : : :✨ :🔥 : :⭐ :🔧 : : : : : : : : : :⏩ : : : : : : : : : "
  export _prompt_alexis_git_symbols_map="
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

  _old_optind=${OPTIND}
  while getopts s: OPTION; do
    case ${OPTION} in
      s)
        _prompt_alexis_git_symbols="${OPTARG}"
    esac
  done
  OPTIND=${_old_optind}
  unset _old_optind
}

prompt_alexis_posix_help() {
  echo "alexis prompt is a multiline prompt which display:
  * an empty line to separate one command from another;
  * a git line if you are in a git repository (see below);
  * the host and working directory line (as classical prompts);
  * an indicator of the exit status of the last command.

The git line is based on the god-bless-git plugin (github.com/AlexisBRENON/god-bless-git) and is similar to the oh-my-git project. It's a colorful line with plenty informations.

List of the prompt options:
  ${BWhite:-}-s${ColorReset:-} <symbols>
      A colon separated string representing symbols to use in the git line.
      Default:
        \"   :: : : :  : : : : : :🔥 : : : : : :✨ :🔥 : :⭐ :🔧 : : : : : : : : : :⏩ : : : : : : : : : \"
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
}

unset PROMPT_ALEXIS_PATH
