#!/usr/bin/env bash

# Start a process identified by its name.
#
# Please note that the name of the process is the "basename" of the file that is
# the process executable. The process executable must be in the same directory
# that this script.
#
# Usage:
#
#        ./process-start.sh <process name> [<args>...]
#
#        ex: ./process-start.sh process1.sh
#        ex: ./process-start.sh process1.sh 10

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
__DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"; readonly __DIR__

if [ $# -eq 0 ]; then
  printf "Usage: %s <process name> [<args>...]\n" "${0}"
  exit 1
fi

declare -r PROCESS_NAME="${1}"; shift
declare -r PID_FOLDER="/tmp/${PROCESS_NAME}-pids"
declare -r PROCESS_PATH="${__DIR__}/${PROCESS_NAME}"

# Sanity check

if [ ! -d "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") does not exist! Please create it!\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

if [ ! -x "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") exists, but it is not accessible! (add execute permission)\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

if [ ! -w "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") exists, but it is not writable! (add write permission)\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

if [ ! -f "${PROCESS_PATH}" ]; then
  printf "FATAL: the executable \"%s\" cannot be found!\n\n" "${PROCESS_PATH}"
  exit 1
fi

if [ ! -r "${PROCESS_PATH}" ]; then
  printf "FATAL: the executable \"%s\" is not readable!\n\n" "${PROCESS_PATH}"
  exit 1
fi

if [ ! -x "${PROCESS_PATH}" ]; then
  printf "FATAL: the executable \"%s\" is not executable!\n\n" "${PROCESS_PATH}"
  exit 1
fi

# OK... let's start

echo "Start process \"${PROCESS_NAME}\" (args: [${*}])"
/bin/nohup "${PROCESS_PATH}" "${@}" 0<&- &>/dev/null &
