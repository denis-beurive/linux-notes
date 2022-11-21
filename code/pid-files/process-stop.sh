#!/usr/bin/env bash

# Stop a process identified by its name.
#
# Usage:
#
#        ./process-stop.sh <process name>
#
#        ex: ./process-stop.sh process1.sh

if [ $# -ne 1 ]; then
  printf "Usage: %s <process name>\n\n" "${0}"
  exit 1
fi

declare -r PROCESS_NAME="${1}"
declare -r PID_FOLDER="/tmp/${PROCESS_NAME}-pids"
declare -ri MAX_STOP_REQUESTS=3

# Test whether a process identified by its PID is running or not.
#
# Please note that you may need to adapt this function. Check for the
# option "-h" for the "ps" command.
#
# @param $1 the PID of the process.
# @return if the process is running, then the function returns the 0.
#         Otherwise, it returns the value 1.
function process_is_running {
  if [ $# -eq 0 ]; then
    echo "FATAL: invalid number of parameters for function \"find_process\"!"
    exit 1
  fi
  declare -r pid="${1}"
  declare -i count
  count=$(/bin/ps -h "${pid}" | wc -l)
  if [ "${count}" -eq 0 ]; then return 1; fi
  return 0
}

# Ask a process, identified by its PID, to stop, politely.
#
# The call to this function leaves the targeted process the opportunity to
# perform cleanup tasks.
#
# Please note that the actual function implementation depends on the sample process.
# If you develop your own process, then you probably need to adapt this implementation.
#
# See https://askubuntu.com/questions/575704/how-can-i-wake-a-sleeping-bash-script
#
# @param $1 the PID of the process.
function ask_process_to_stop {
  if [ $# -eq 0 ]; then
    echo "FATAL: invalid number of parameters for function \"ask_process_to_stop\"!"
    exit 1
  fi
  declare -r pid="${1}"
  /bin/pkill -P "${pid}" sleep
}

# Kill a process identified by its PID.
#
# The call to this function kills the targeted process, no matter what it is doing.
#
# @param $1 the PID of the process.
function kill_process {
  if [ $# -eq 0 ]; then
    echo "FATAL: invalid number of parameters for function \"kill_process\"!"
    exit 1
  fi
  declare -r pid="${1}"
  /bin/kill -9 "${pid}"
}

# Sanity check

if [ ! -d "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") does not exist! Please create it!\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

if [ ! -x "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") exists, but it is not accessible! (add execute permission)\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

if [ ! -r "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") exists, but it is not readable! (add read permission)\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

if [ ! -w "${PID_FOLDER}" ]; then
  printf "FATAL: the PID folder for the process \"%s\" (\"%s\") exists, but it is not writable! (add write permission)\n\n" "${PROCESS_NAME}" "${PID_FOLDER}"
  exit 1
fi

PIDS=$(/bin/find "${PID_FOLDER}" -type f | /bin/sed 's/^.*\///g' | /bin/grep -E '^[0-9]+$')
declare -r PIDS

if [ -z "${PIDS}" ]; then
  echo "No process to stop. Exit"
  exit 0;
fi

declare -i count
declare -i pid
while IFS= read -r pid; do
  echo "Stopping the process \"${PROCESS_NAME}\" which PID is ${pid}"
  pid_file="${PID_FOLDER}/${pid}"

  # If the process is running, then send the signal to the process. Otherwise, take care of the next PID
  if process_is_running "${pid}"; then

    echo "\"${PROCESS_NAME}\" is running (PID ${pid}). Ask it to stop, politely"
    ask_process_to_stop "${pid}"
  else
    echo "The process \"${PROCESS_NAME}\" which PID is ${pid} is not running. Skip"
    continue;
  fi

  # Wait for the process to stop
  count=0
  while process_is_running "${pid}" && [ ${count} -lt ${MAX_STOP_REQUESTS} ]; do
    sleep 1;
    count=$((count + 1))
    echo "Process \"${PROCESS_NAME}\" is still running... wait (${count}/${MAX_STOP_REQUESTS})"
  done

  # If the process is still running, then kill it
  if [ $count -eq ${MAX_STOP_REQUESTS} ]; then
    echo "Still running... send \"-9\" to PID ${pid}"
    kill_process "${pid}"
  fi

  # Remove the PID file, if necessary
  if [ -e "${pid_file}" ]; then
    echo "Remove the PID file \"${pid_file}\""
    /bin/rm -f "${pid_file}";
  fi
  echo "Done!"
done <<<"${PIDS}"
