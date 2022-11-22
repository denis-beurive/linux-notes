# Bash

## Path to the current script

```bash
#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
__DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"; declare -r __DIR__
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

> Don't forget the call to `eval`!

Result:

    V1=10
    V2=20
    V3="${V3}"

## Local variable

### Mutable

You can:
* use the keyword "`local`".
* _declare_ the variable using the keyword "`declare`".

```bash
#!/bin/bash

function func {
    local mylocal=10
    declare -i constant=20
    echo "In the function: mylocal = ${mylocal} and constant = ${constant}"
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

### Immutable

Use `local -r` or `declare -r`. For example:

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

> **WARNING**:
> * you can only return an integer value from 0 (included) to 255 (included) !
>   You cannot "return" a string.
> * Keep in mind that, for BASH, 0 means TRUE. Any other values mean FALSE.

Usage:

```bash
#!/usr/bin/env bash

# For BASH, true is 0 and false is any value other than 0.
function true_or_false {
  if [ "${1}" == "true" ]; then return 0; fi
  if [ "${1}" == "false" ]; then return 1; fi
  return 2
}

if true_or_false "true"; then
  echo "true"
else
  echo "not true"
fi # => rue

if true_or_false "false"; then
  echo "true"
else
  echo "not true"
fi # => not true

if true_or_false "other value"; then
  echo "true"
else
  echo "not true"
fi # => not true

if true_or_false "true" && true_or_false "true"; then
  echo "true and true"
else
  echo "not true and true"
fi # => true and true

if ! true_or_false "false" && ! true_or_false "false"; then
  echo "not false and not false"
else
  echo "not \"not false and not false\""
fi # => not false and not false

if true_or_false "true" || true_or_false "false"; then
  echo "true or false"
else
  echo "not \"true or false\""
fi # => true or false

if true_or_false "true" && [ $((1+1)) -eq 2 ]; then
  echo "true and 1+1=2"
else
  echo "not \"true and 1+1=2\""
fi # => true and 1+1=2
```

## New line in strings

Use `$'\n'`

```bash
text="line 1\nline 2"
echo "${text}"           # => line 1\nline 2
printf "%s\n" "${text}"  # => line 1\nline 2

text="line1"$'\n'"line2"
echo "${text}"           # => line 1
                         #    line 2
printf "%s\n" "${text}"  # => line 1
                         #    line 2
```

## Wait forever

```bash
sleep infinity
```

Or (it can be interesting):

```bash
# Run forever
sleep infinity &
wait $! # $! means PID of last backgrounded process
```

## Execute a handler when the script terminates

```bash
function cleanup() {
    # Delete my PID file.
    rm -f "/tmp/${$}"
}

trap cleanup EXIT
```

## Variable name defined as a viarable

Use the syntax `${!variable_name}`:

```bash
text="this is a text"
variable_name='text'
echo ${!variable_name}   # => this is a text
```

Test whether a variable, which name is stored in a variable, is set or not:

```bash
text=""
variable_name='text'
if [ -n "${!variable_name+_}" ]; then
  echo "The variable ${variable_name} is set"
else
  echo "The variable ${variable_name} is not set"
fi # => The variable text is set

variable_name='unexpected_name'
if [ -n "${!variable_name+_}" ]; then
  echo "The variable ${variable_name} is set"
else
  echo "The variable ${variable_name} is not set"
fi # => The variable unexpected_name is not set

```

## Using hash tables

```bash
# Create an array map
declare -A array_map=([key1]='value1' [key2]='value2')

# Add an entry
array_map["key3"]='value3'
printf "%s\n" "${array_map["key3"]}" # => value3

# Test if an entry exists
array_map["key3"]='value3'
if [ ${array_map["key3"]+_} ]; then
  echo "The entry key3 is set"
else
  echo "The entry key3 is not set"
fi # => The entry key3 is set

array_map["key3"]=''
if [ ${array_map["key3"]+_} ]; then
  echo "The entry key3 is set"
else
  echo "The entry key3 is not set"
fi # => The entry key3 is set

if [ ${array_map["unexpected_key"]+_} ]; then
  echo "The entry unexpected_key is set"
else
  echo "The entry unexpected_key is not set"
fi # => The entry unexpected_key is not set

# Loop over the keys
for key in "${!array_map[@]}"; do
  printf -- "- key (%s)\n" "${key}"
done # => - key (key2)
     #    - key (key3)
     #    - key (key1)

# Sort the keys, then loop.
IFS=$'\n'
declare -a keys=($(sort <<<"${!array_map[*]}")); unset IFS
for key in "${keys[@]}"; do
  printf -- "- key (%s)\n" "${key}"
done # => - key (key1)
     #    - key (key2)
     #    - key (key3)

# Delete en entry
unset "array_map[\"key3\"]"
if [ ${array_map["key3"]+_} ]; then
  echo "The entry key3 is set"
else
  echo "The entry key3 is not set anymore"
fi # => The entry key3 is not set anymore
```

## Using SED for current operations

First, you should always activate the use of extended regular expressions (using the option `-E`).

```bash
TEXT=$(cat <<'EOS'
a line1
b line2
c line3
1 line4
2 line5
EOS
); declare -r TEXT
```

### Filter: keep only the lines that match a given regular expression

Use the `p` command.

```bash
echo "a line1"  | sed -n -E '/^[a-z]+\s+.+/p'  # => a line1
echo "a1 line1" | sed -n -E '/^[a-z]+\s+.+$/p' # =>
echo "${TEXT}"  | sed -n -E '/^[a-z]+\s+.+/p'  # => a line1
                                               #    b line2
                                               #    c line3
echo "/path/to/bin.exe"     | sed -n -E '/^\/?[a-z]+(\/[a-z]+)?\/[a-z]+\.exe$/p' # => /path/to/bin.exe
echo "/path/bin.exe"        | sed -n -E '/^\/?[a-z]+(\/[a-z]+)?\/[a-z]+\.exe$/p' # => /path/bin.exe
echo "/path/to/the/bin.exe" | sed -n -E '/^\/?[a-z]+(\/[a-z]+)?\/[a-z]+\.exe$/p' # =>
```

### Delete only the lines that match a given regular expression.

Use the `d` command.

```bash
echo "a line1"  | sed -E '/^[a-z]+\s+.+/d'     # =>
echo "a1 line1" | sed -E '/^[a-z]+\s+.+$/d'    # => a1 line1
echo "${TEXT}"  | sed -E '/^[a-z]+\s+.+$/d'    # => 1 line4
                                               #    2 line5
```

You can set multiple "filters" at once:

```bash
echo "the fox"  | sed -E '/^the\s+/d; /\s+fox$/d'  # =>
echo "the dog"  | sed -E '/^the\s+/d; /\s+fox$/d'  # =>
echo "a dog"    | sed -E '/^the\s+/d; /\s+fox$/d'  # => a dog
```

### Search and replace with "captures".

The content of the first capture is held by the variable `\1`.
The content of the second capture is held by the variable `\2`...

```bash
echo "a line1"   | sed -E 's/^[a-z]+\s+(.+)/word \1/'  # => word line1
echo "a1 line1"  | sed -E 's/^[a-z]+\s+(.+)/word \1/' # => a1 line1
```

You can set multiple "converters" at once:

```bash
cho "1234"    | sed -E 's/A/a/g; s/B/b/g' # => 1234
echo "ABCDEF"  | sed -E 's/A/a/g; s/B/b/g' # => abCDEF
```

### Search and replace all occurrences.

Une the option `g`.

```bash
echo "a line1"   | sed -E 's/([a-z]+)/word/g'  # => word word1
echo "a1 line1"  | sed -E 's/([a-z]+)/word/g'  # => word1 word1
```

### Mixing deletion and replacement

```bash
echo "the fox"  | sed -E '/^the\s+/d; s/\s+(.+)$/ dog/;' # =>
echo "a fox"    | sed -E '/^the\s+/d; s/\s+(.+)$/ dog/;' # => a dog
```

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
>
> You can force the value of the last command of a pipeline to be 0 with this trick: `command1 | command2 | true`

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

## What is the path to the executed command ?

You all know the `which` command. But did you know this trick ?

```bash
$ strace true 2>&1 > /dev/null | head -n 1
execve("/bin/true", ["true"], [/* 60 vars */]) = 0
```

> Obviously, you'd better user `which`. But the use of `strace` can be "enlightening" :-)

## Designing daemons for clean stopping

### Using PID files

One way to stop a process is to use a "STOP file." The process regularly looks for a predefined file. If this file exists, then the process stops itself.

This technique may be tricky if several instances of the same process are running. Indeed, once the process stopped, the "STOP file" must be removed (otherwise it becomes impossible to start the process again). If more than one instance of the process is running, then you must wait for all instances to stop before you can remove the "STOP file" (otherwise, some instances will continue to run).

The folling scripts implement:
* [process.sh](code/process.sh): a simple process that is launched as a daemon. Any number of this process can be launched.
* [stop-process.sh](code/stop-process.sh): a script used to stop all the instances of the process.

Start as many scripts as you want (for example, 3 instances):
```bash
$ bin/nohup /path/to/process.sh --fake-arg 0<&- &>/dev/null &
$ bin/nohup /path/to/process.sh --fake-arg 0<&- &>/dev/null &
$ bin/nohup /path/to/process.sh --fake-arg 0<&- &>/dev/null &
```

Then stop all the instances:

```bash
echo "process.sh" | /path/to/stop-process.sh
```

> Please note:
> * that the name of the process to stop is passed to the "stop-process.sh" through the standard input, and not through command line arguments. The reason for this choice is the following: in order to find out whether the process is executing or not, we parse the output of the "ps" command. We are looking for the string that represents the name of the process to stop. If this name is part of the command line of "stop-process.sh," then we'd always find it.
> * this technique is not 100% bulletproof. If the name of the process to stop (that is "`process.sh`") is used in a command line that does not signal the process, then this technique does not work properly. One way to solve this issue is to base the detection of the process based on the presence of a "PID file" (that way, we don't rely on the output of "ps" to determine whether the process is running or not).

### Using PID files

[This directory](code/pid-files) contains an example that illustrates the use of PID files.

When a process \"process__ID__.sh\" (with `__ID__` = `[1, 2, 3, 4, 5, 6]`) starts, it creates PID file in the directory `/tmp/process__ID__.sh-pids`. The name of the file is the PID of the process (ex: `12654`).

> See variable `PID_FOLDER`:
>
> ```bash
> declare -r PROCESS_NAME="process__ID__.sh"         # __ID__ = 1, 2, 3, 4, 5, 6
> declare -r PID_FOLDER="/tmp/${PROCESS_NAME}-pids"
> ```

For example, when the process `process1.sh` starts, it creates a PID file in the directory `/tmp/process1.sh-pids`. The name of this file is the PID of the process.

When you call the script [process-stop.sh](code/pid-files/process-stop.sh) with the name of the process as argument (ex: `process1.sh`: `process-stop.sh process1.sh`), it will look in the directory that contains the PIDs (`/tmp/process1.sh-pids`) associated with the process.

Using this example:

Generate the processes for tests: execute the script `generate-processes.sh`.

This script generates 6 process. After the execution of this script, you have:

```bash
$ ls -1 process*.sh
process1.sh
process2.sh
process3.sh
process4.sh
process5.sh
process6.sh
```

Check if the processes are running:

```bash
$ ps awx | sed -rn '/process[[:digit:]]+\.sh/p'
```

Start / stop all processes:

```bash
./all-processes.sh start # or ./all-processes.sh start 10
./all-processes.sh stop
```

Start / stop a single process (for example `process1.sh`):

```bash
./process-start.sh process1.sh # or ./process-start.sh process1.sh 10
./process-stop.sh process1.sh
```

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
