#!/usr/bin/env bash
# Usage:
#
#        echo "process.sh" | ./stop-process.sh


# Escape a string.
# This function convert:
# - "." into "\."
# - "/" into "\/".
# - "-" into "\-".
# @param $1 the string the escape.
# @return the escaped string.
function escape_for_regex {
  if [ $# -eq 0 ]; then
    echo "FATAL: invalid number of parameters for function \"escape_for_regex\"!"
    exit 1
  fi
  declare -r text="${1}"
  echo "$(echo "${text}" | sed -e 's/\./\\\./g' | sed -e 's/\//\\\//g' | sed -e 's/\-/\\\-/g')"
}

# This AWK script is used by the function "find_process".
AWK_PS_SEARCH=$(cat <<'EOS'
{
    line = $0;
    data = substr($0, 32);
    if (data ~ /^__PATTERN__\s*$/         ||
        data ~ /^__PATTERN__\s+/          ||
        data ~ /(\s+|\/)__PATTERN__\s+/   ||
        data ~ /(\s+|\/)__PATTERN__\s*$/  ||
        data ~ /\[__PATTERN__\]/) {
        printf("found")
        exit(0)
    }
}
EOS
); declare -r AWK_PS_SEARCH

# Search for a process identified by its name and returns a status that tells whether it has been found or not.
# @param $1 the basename of the executable associated with the process.
# @return if the process is found, then the function returns the value "found".
#         Otherwise, it returns the value "not found".
function find_process {
  if [ $# -eq 0 ]; then
    echo "FATAL: invalid number of parameters for function \"find_process\"!"
    exit 1
  fi

  local ps_found command
  ps_found=$(/bin/ps -e -o pid,lstart,args)
  declare -r ps_found
  declare -r process_name="$(escape_for_regex "$(basename "${1}")")"
  command=$(echo "${AWK_PS_SEARCH}" | sed -e "s/__PATTERN__/${process_name}/g"); declare -r command
  declare -r status=$(echo "${ps_found}" | awk "${command}") # return "found" or ""
  if [ -z "${status}" ]; then echo "not found"; else echo "found"; fi
}

read process
declare -r process
declare -r stop_file="/tmp/${process}.stop"

ps_status=$(find_process "${process}")
if [ "${ps_status}" == "not found" ]; then exit 0; fi

touch "${stop_file}"
while [ "${ps_status}" == "found" ]; do
  sleep 1
  ps_status=$(find_process "${process}")
done
rm -f "${stop_file}"
