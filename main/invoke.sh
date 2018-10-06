#! /bin/sh

# shellcheck source=./utils/init.sh
. "${STEROPE_ROOT}/utils/init.sh"

# shellcheck source=./setup/init.sh
. "${STEROPE_ROOT}/setup/init.sh"
f_sterope_setup

printf 'Sterope prompt version %s\n' "${STEROPE_VERSION}"
printf '%s\n' "${v_sterope_help_message}"
exit 0

