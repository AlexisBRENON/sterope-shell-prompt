#! /bin/sh

readonly LOG_FILE="/tmp/$(basename "$0").log"
debug()   { printf "[DEBUG]   %s\\n" "$*" | tee -a "$LOG_FILE" >&2 ; }
info()    { printf "[INFO]    %s\\n" "$*" | tee -a "$LOG_FILE" >&2 ; }
warning() { printf "[WARNING] %s\\n" "$*" | tee -a "$LOG_FILE" >&2 ; }
error()   { printf "[ERROR]   %s\\n" "$*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { printf "[FATAL]   %s\\n" "$*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

