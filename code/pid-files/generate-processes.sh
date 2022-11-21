#!/usr/bin/env bash
# This script generate processes for testing purposes.

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
__DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"; declare -r __DIR__

declare -ri PROCESS_COUNT=6

for i in $(seq 1 ${PROCESS_COUNT}); do
  process_name=$(echo "process__ID__.sh" | sed -e "s/__ID__/${i}/")
  pid_dir=$(echo "/tmp/process__ID__.sh-pids" | sed -e "s/__ID__/${i}/")
  sed -e "s/__ID__/${i}/" process__ID__.sh > "${process_name}"
  chmod +x "${process_name}"
  if [ ! -d "${pid_dir}" ]; then
    echo "Create directory \"${pid_dir}\""
    mkdir -p "${pid_dir}";
  fi
done
ls -l "${__DIR__}"/process*.sh
