#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
readonly __DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

config=$(cat <<"EOS"
altscreen on

chdir "${__DIR__}/www"
screen -t "www" 1

chdir "${__DIR__}/tools"
screen -t "data" 2

chdir "${HOME}"
screen -t "${HOME}" 3

chdir "${HOME}"
screen -t "root@${HOME}" 4

EOS
)

eval "readonly conf=\"${config}\""
echo "${conf}" > /dev/shm/screen.rc

screen -c /dev/shm/screen.rc && rm /dev/shm/screen.rc