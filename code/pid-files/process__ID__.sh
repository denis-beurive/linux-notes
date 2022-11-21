#!/usr/bin/env bash

# This script is a simple script used simulate a daemon.
#
# Usage:
#
#        ./process1.sh [<wait duration in seconds>]
#
# Example:
#
#        ./process-start.sh process1.sh
#        => the process will end immediately after being told to end its execution.
#
#        ./process-start.sh process1.sh 10
#        => the process will wait 10 seconds after being told to stop its execution.
#           This functionality allows us to simulate a busy process that does not
#           want to terminate its execution.

declare -r PROCESS_NAME="process__ID__.sh"
declare -r PID_FOLDER="/tmp/${PROCESS_NAME}-pids"
declare -r PID_FILE="${PID_FOLDER}/${$}"
declare -i WAITING_TIME=0 # declared as a constant later

# Perform initialisation operations during the shutdown.
function startup() {
  /bin/date +s > "${PID_FILE}"
}

# Perform cleaning operations during the shutdown.
function cleanup() {
  sleep "${WAITING_TIME}" # Simulate a process that does not end
  rm -f "${PID_FILE}"
}

if [ $# -ne 0 ]; then WAITING_TIME=${1}; fi
declare -r WAITING_TIME

# Start.
startup
# Note: "kill -9" (SIGKILL) cannot be trapped. However, "kill -2" (SIGINT) can.
#       To get the list of available signals: trap -l (be aware that some signals are not suitable for this application)
trap cleanup EXIT

# Run forever.
sleep infinity &
wait $! # $! means PID of last backgrounded process.
