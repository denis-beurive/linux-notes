#!/usr/bin/env bash
# Usage:
#
#        ./all-processes.sh start|stop [<duration in seconds>]
#
#        ex: ./all-processes.sh start
#            ./all-processes.sh start 10
#            ./all-processes.sh stop

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
__DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"; declare -r __DIR__

if [ $# -lt 1 ]; then
  printf "Usage: %s start|stop [<duration>]\n" "${0}"
  exit 1
fi

# Parse the command line

ACTION=""
DURATION=""
if [ "${1}" == "start" ]; then
  ACTION="start"
  if [ $# -eq 2 ]; then DURATION="${2}"; fi
fi
if [ "${1}" == "stop" ]; then ACTION="stop"; fi
if [ -z "${ACTION}" ]; then
  echo "FATAL: invalid action \"${ACTION}\" (expected \"start\" or \"stop\")"
  exit 1
fi

# OK. Process

declare -r ACTION
declare -r DURATION
declare -ri PROCESS_COUNT=6
declare -r STOPPER="${__DIR__}/process-stop.sh"
declare -r STARTER="${__DIR__}/process-start.sh"

for i in $(seq 1 ${PROCESS_COUNT}); do
  process_name=$(echo "process__ID__.sh" | sed -e "s/__ID__/${i}/")
  if [ "${ACTION}" == 'start' ]; then
    echo "Start process \"${process_name}\" (duration: <${DURATION}>)"
    ${STARTER} "${process_name}" "${DURATION}"
  else
    echo "Stop process \"${process_name}\""
    ${STOPPER} "${process_name}"
  fi
done
