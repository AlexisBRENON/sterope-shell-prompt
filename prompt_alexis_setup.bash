#! /usr/bin/env bash

get_absolute_dirname() {
  SOURCE="$1"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [ "$SOURCE" != "/*" ] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  ( cd -P "$( dirname "$SOURCE" )" && pwd )
  unset DIR
  unset SOURCE
}

PROMPT_ALEXIS_PATH=""
while [ ! -e "${PROMPT_ALEXIS_PATH}/prompt_alexis_setup.bash" ] ; do
  PROMPT_ALEXIS_PATH="$(get_absolute_dirname "$1")"
  shift
done
. "${PROMPT_ALEXIS_PATH}/init.sh"

prompt_alexis_bash_build_prompt() {
  PS1="$(prompt_alexis_build_prompt)"
}

prompt_alexis_setup() {
  prompt_alexis_posix_setup "$@"

  export _prompt_alexis_async_refresh_command="printf '\k'"
  PROMPT_COMMAND="prompt_alexis_bash_build_prompt"
}

alias prompt_alexis_help=prompt_alexis_posix_help
