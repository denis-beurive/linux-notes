# Bash

## Path to the current script

```bash
#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
readonly __DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
```

## Create a file "in memory"

    echo "toto" > /dev/shm/your_file

This file is created in a shared memory (shm) area.
Thus, it can be accessed by any process.

> To delete this file, just use `rm`: `rm /dev/shm/your_file`.

## Test if a function is defined

```bash
type function_name &>/dev/null
if [ $? -eq 1 ]; then
    echo "function_name is NOT defined!"
fi
```

## Test if a variable is defined

```bash
if [ -z ${VARNAME+x} ]; then
    echo "Variable VARNAME is NOT defined!";
fi
```

## The "noop" command

```bash
function dummy_function() {
    :
}
```

A dummy function (that does nothing) may be useful if you want to test if a given script has been sourced or not: you just check whether the dummy function is defined or not.

## Get a subtring

```bash
s="abcdefghi"
a=${s:0:3}
echo "$a"
abc
```

## Default value

### If variable is not set or its value is an empty string

If the variable `$variable` is set, and if its value is not an empty string, then its value is used. Otherwise, the default value ("`default value`" or "`default_value`") is used.

    echo "1> ${variable:-default_value}"
    echo "2> ${variable:-default value}"
    variable=""
    echo "3> ${variable:-"default value"}"
    variable="the value"
    echo "4> ${variable:-default value}"

Result:

    1> default_value
    2> default value
    3> default value
    4> the value

### If variable is set and its value is not an empty string

If variable is set and its value is not an empty string, then the default value is used. Otherwise, the value used is an empty string.

    echo "1> ${variable:+default_value}"
    variable=''
    echo "2> ${variable:+default_value}"
    variable='the value'
    echo "3> ${variable:+default_value}"

Result:

    1> 
    2> 
    3> default_value

## Heredoc with substitutions

```bash
#!/bin/bash

readonly V1=10
readonly V2=20

string=$(cat <<"EOS"
V1="${V1}"
V2="${V2}"
V3=\"\${V3}\"
EOS
)

eval "s=\"${string}\""
echo "${s}"
```

Result:

    V1=10
    V2=20
    V3="${V3}"

## Local variable into functions

Use the keyword "`local`":

```bash
#!/bin/bash

function func {
    local mylocal=10
    echo "In the function: mylocal = ${mylocal}"
}

func

echo "Outside the function: mylocal = ${mylocal}"
```

Result:

    In the function: mylocal = 10
    Outside the function: mylocal = 

If you remove the keyword "`local`", then the variable `mylocal` is not local to the function anymore. Let's make the test:

```bash
#!/bin/bash

function func {
    mylocal=10 ### No "local" here !!!
    echo "In the function: mylocal = ${mylocal}"
}

func

echo "Outside the function: mylocal = ${mylocal}"
```

Result:

    In the function: mylocal = 10
    Outside the function: mylocal = 10

## Local and readonly

Use `local -r`. For example:

```bash
#!/bin/bash

function my_function {
    local -r variable=10
    echo ${variable}
}
my_function
```

## Return from a function

    return [-n]

## Find and replace

Example:

    echo "toto.git" | sed -e 's/.git$//'

## Immediately exit if any command has a non-zero exit status

Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status. 

    set -e

> See [The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin)

## Treat unset variables and parameters as an error

Treat unset variables and parameters other than the special parameters `@` or `*` as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.

    set -u

> See [The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin)

## Do not ignore the status of the last command of a pipeline

If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.

    set -o pipefail

> See [The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin)

## Bash "strict mode"

See [Use the Unofficial Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

```bash
# Turn on "strict mode".
# - See http://redsymbol.net/articles/unofficial-bash-strict-mode/.
# - See https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin
#
# -e: exit immediately if a pipeline, which may consist of a single simple command, a list,
#     or a compound command returns a non-zero status. 
# -u: treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as
#     an error when performing parameter expansion. An error message will be written to the
#     standard error, and a non-interactive shell will exit.
# -o pipefail: if set, the return value of a pipeline is the value of the last (rightmost)
#              command to exit with a non-zero status, or zero if all commands in the pipeline
#              exit successfully.
set -eu -o pipefail
```

## Add a directory to PATH only if it is not already declared

    GRADLE_PATH="${HOME}/Softwares/gradle-6.3/bin"
    [[ ":${PATH}:" != *":${GRADLE_PATH}:"* ]] && PATH="${GRADLE_PATH}:${PATH}"

## Bash customization

### Add bookmark capability into Bash

Add this lines into your file "`~/.bashrc`":

```bash
if [ -d "${HOME}/.bookmarks" ]; then
    export CDPATH=".:${HOME}/.bookmarks:/"
    alias goto="cd -P"
    _goto() {
        local IFS=$'\n'
        COMPREPLY=($(compgen -W "$(/bin/ls ~/.bookmarks)" -- ${COMP_WORDS[COMP_CWORD]}))
    } && complete -F _goto goto
fi

bm() {
    # Set a bookmark
    # bm <target directory> <alias>

    local _target="${1}"
    local _alias="${2}"

    if [ ! -d "${_target}" ]; then
        printf "\"%s\" is not a directory!\n" "${_target}"
        return
    fi

    local _bmp="${HOME}/.bookmarks/@${_alias}"

    if [ -L "${_bmp}" ]; then
      rm -i "${_bmp}"
    fi

    ln -s "${_target}" "${_bmp}"
}

bmls() {
    # List bookmarks entries
    ls -1 "${HOME}/.bookmarks"
}
```

> Do not forget to reload the content of "`~/.bashrc`": `. ~/.bashrc`.

Create a bookmark entry:

```bash
bm /var/log log
```

Go to entry location:

```bash
goto @log
```

> Type "`@`" then press `[tab]`.

List all bookmark entries:

```bash
bmls
```

# ls, find... with Perl regex

Example:

```bash
find ~/ -type f | perl -ne 'chomp; print "$_\n" if ($_ =~ m/.+\.json$/)'
```

> See [Perl One Liners](perl.md)

Inside a loop, it can be pretty handy:

```bash
OLDIFS=$IFS
IFS=$'\n'
for image in $(find "/home/denis/Images" -type f | perl -e '@v=(); while(<>) { chomp;  push @v, $_ if ($_ =~ m/\.png$/i)} print join "\n", @v'); do
    target=$(printf "%s" "${image}" | perl -pe 's/\s+/_/g')
    printf "image:  %s\n" "${image}"
    printf "target: %s\n" "${target}"
    if [ -f ${image} ]; then
        ls ${image}
    fi
    printf "\n"
done
IFS=$OLDIFS
```

> This code does not work if file names contain "`\n`"... If you need to manipulate files which names contain "\n", then forget Bash. Use Perl, Python, PHP or Ruby instead.
>
> Wonder about `IFS` ? Read [this](https://mywiki.wooledge.org/IFS).

# Calcul on the command line

```bash
result=$((1024 * 1024))
echo $result
result=$((result * 1024))
echo $result
```
