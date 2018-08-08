#! /bin/sh

# shellcheck source=./utils/logging.sh
. "${STEROPE_ROOT}/utils/logging.sh"

# shellcheck source=./setup/init.sh
. "${STEROPE_ROOT}/setup/init.sh"
f_sterope_setup

printf '%s' "${v_sterope_help_message}"
exit 0

