#! /usr/bin/env bash

f_prompt_alexis_bash_setup() {
  . "${PROMPT_ALEXIS_PATH}/functions/bash.sh"
  PROMPT_COMMAND="f_prompt_alexis_bash_build_prompt"
}

