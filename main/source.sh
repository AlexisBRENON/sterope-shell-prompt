#! /bin/sh

# shellcheck source=./utils/logging.sh
. "${STEROPE_ROOT}/utils/logging.sh"

# shellcheck source=./setup/init.sh
. "${STEROPE_ROOT}/setup/init.sh"
f_sterope_setup

# Load required functions
# shellcheck source=./lib/init.sh
. "${STEROPE_ROOT}/lib/init.sh"

# Set prompt

