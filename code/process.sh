#!/usr/bin/env bash

declare -r PID_FILE="/tmp/process.pid"
declare -r STOP_FILE="/tmp/process.sh.stop"

# Perform initialisation operations during the shutdown.
function startup() {
  echo "${$}" > "${PID_FILE}"
}

# Perform cleaning operations during the shutdown.
function cleanup() {
  rm -f "${PID_FILE}"
}

# Start.
startup
trap cleanup EXIT # Note: "kill -9" cannot be trapped.

# Wait until a STOP file is created.
while :
do
	sleep 1
	if [ -e "${STOP_FILE}" ]; then
    exit 0
	fi
done
