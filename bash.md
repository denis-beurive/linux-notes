# Bash

## Path to the current script

```bash
#!/usr/bin/env bash

__FILE_NAME__="${BASH_SOURCE[0]}"
while [ -h "${__FILE_NAME__}" ] ; do __FILE_NAME__="$(readlink "${__FILE_NAME__}")"; done
__DIR__="$( cd -P "$( dirname "${__FILE_NAME__}" )" && pwd )"
declare -r __DIR__
__FILE_NAME__="$(basename "${__FILE_NAME__}")"
declare -r __FILE_NAME__
declare -r __FILE__="${__DIR__}/${__FILE_NAME__}"

echo "${__DIR__}"        # => /c/Users/denis.beurive/CLionProjects/nukefrlis/test
echo "${__FILE_NAME__}"  # => test-bash.sh
echo "${__FILE__}"       # => /c/Users/denis.beurive/CLionProjects/nukefrlis/test/test-bash.sh
```

> This is pretty useful because it allows you to build absolute paths relatively to the
> path of the script itself.

## Create a file "in memory"

    echo "toto" > /dev/shm/your_file

This file is created in a shared memory (shm) area.
Thus, it can be accessed by any process.

> To delete this file, just use `rm`: `rm /dev/shm/your_file`.

## Remove CTRL-M

```bash
sed -iE 's/\r//g' /file/name
```

Under Mac OS, the previous command may not work properly. In this case, you should execute:

```bash
sed -iE "s/$(printf '\r')//g" /file/name
```

Useful functions:

```bash
function trim_ctrl_m_mac { 
  sed -E "s/$(printf '\r')//g"
}

function trim_ctrl_m_linux { 
  sed -E "s/\r//g" 
}

# Examples

printf '[This is a test\r]' | trim_ctrl_m_linux   # => [This is a test]
printf '[This is a test\r]' | trim_ctrl_m_mac     # => [This is a test]
```

## Find out if you are in a subshell

```bash
(if [ "$(exec sh -c 'echo "${PPID}"')" != "$$" ]; then
    echo "you are in a subshell"
fi)  # => will print "you're in a subshell"
```

## Set an exit hanlder

```bash
function finish {
  # Your cleanup code here
  :
}
trap finish EXIT
```

But be careful with sub-shells! This is a trap! You probably don't want your handler to be executed at the end of a sub-shell.

```bash
function finish {
  if [ "$(exec sh -c 'echo "${PPID}"')" == "$$" ]; then
      echo "you are NOT in a subshell"
      # Your cleanup code here
  fi
}
trap finish EXIT
```

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

You can also use "`:`" in an "empty" `if then else` construct.

```bash
if [ "a" = "a" ]; then
  :
else
  :
fi
```

## Get a subtring

Syntax: `${string:<from>:<length>}` (`<from>` starts at 0)

> If `length` is omitted, it means "to the end".

```bash
string="abcd"
echo ${string:0:1}  # => a
echo ${string:0:2}  # => ab
echo ${string:1:1}  # => b
echo ${string:1:2}  # => bc
echo ${string:1}    # => bcd
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

readonly V1="10" # you can use "declare -r" instead
readonly V2="20" # you can use "declare -r" instead

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

## Use xargs

Please note the difference between the first and the second example. In the second example, we use a shell to interpret the command.

Example 1:

```bash
$ echo "bla bla bla" | xargs -I x printf "<%s>\n" x
<bla bla bla>

$ echo "bla bla bla" | xargs -I %% printf "<%s>\n" %%
<bla bla bla>
```

Example 2:

```bash
$ echo a b c | xargs -I %% sh -c 'printf "<%s>\n" %%'
<a>
<b>
<c>

$ echo a b c | xargs -I %% sh -c 'printf "<%s> <%s> <%s>\n" %%'
<a> <b> <c>
```


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
    local -r variable=10 # you can use "declare -r" instead
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

## Passing variable by reference (sort of)

What if you want a function to return a hash map ? It is possible... but you have to serialize the hash. That's uselessly complex.

What if you want a function that prints data to STDOUT to return a string of characters ? You can't.

Well, there is a workaround to these BASH limitations. You can assign a value to a variable if you have the name of the variable. Thus, the workaround is to pass the name of the variable as a parameter to the function.

Illustration:

```bash
# Print a form that asks for a "yes or no" question.
#
# WARNING: do not call this function using $(...) !
#          Indeed, if you do so, messages will not be printed to the standard output.
#          In order to retrieve the response from the user, you must use an intermediate variable
#          whose name is passed through the third parameter.
#
# @param $1 the message of the question.
# @param $2 the message to print if the user does not respond by "yes" or "no".
# @param $3 the name of the variable that will be used to store the response.
#           This parameter's value cannot be set to "__response" !!!
# @return the response of the user. It can be "yes" or "no"
function yes_no_form {
  if [ $# -ne 3 ]; then
    log_error "invalid number of parameters for function \"yes_no_form\"!"
  fi
  declare -r message="${1}"
  declare -r retry="${2}"
  declare -r var="${3}"

  if [ "${var}" == "__response" ]; then
    echo "ERROR: reserved parameter value (\"${var}\") for function \"yes_no_form\""
    exit 1
  fi

  local __response
  while true; do
    read -r -p "${message}: " __response
    case "${__response}" in
        [Yy]* ) __response="yes";;
        [Nn]* ) __response="no";;
        * )     __response="";
                echo "${retry}";;
    esac
    if [ -n "${__response}" ]; then break; fi
  done

  # HERE !!! look at the use of "eval" !!!
  #
  # We set the value of the variable whose name is given by the variable "var".
  # This is like using references.
  eval "${var}"="${__response}"
}

response="" # this line is not mandatory, but is is cleaner.
yes_no_form "What is your decision? ([Y]es or [N]o)" "Invalid response" "response"
printf "Your decision is \"%s\"\n" "${response}"
```

## Using arrays

```bash
#!/usr/bin/env bash

declare -a array=('e1' 'e2' 'e3')

# Add an element.
array[3]='e4'

# Length of the array
printf "Length of array: %d\n" "${#array[@]}"  # => 4

# Access the elements of the array
printf "array[0]=%s\n" "${array[0]}" # => e1
printf "array[1]=%s\n" "${array[1]}" # => e2
printf "array[2]=%s\n" "${array[2]}" # => e3
printf "array[3]=%s\n" "${array[3]}" # => e4

# Split a string into an array
IFS=' ' read -r -a array <<< "a1 a2 a3"
printf "array[0]=%s\n" "${array[0]}" # => a1
printf "array[1]=%s\n" "${array[1]}" # => a2
printf "array[2]=%s\n" "${array[2]}" # => a3

IFS=', ' read -r -a array <<< "a1, a2, a3"
printf "array[0]=<%s>\n" "${array[0]}" # => <a1>
printf "array[1]=<%s>\n" "${array[1]}" # => <a2>
printf "array[2]=<%s>\n" "${array[2]}" # => <a3>

# Loop over an array

array=('e1' 'e2' 'e3')
for e in "${array[@]}"; do
  printf "[%s]\n" "${e}"
done # => [a1]
     #    [a2]
     #    [a3]

# Join a array (into a string)
# Thanks to: https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash

join_by() { local d="$1" f="$2"; shift 2 && printf %s "$f" "${@/#/$d}"; }

array=('e1' 'e2' 'e3')
printf "%s\n" "$(join_by ', ' 'a' 'b' 'c')" # => "a, b, c"
printf "%s\n" "$(join_by ',' ${array[*]})"  # => "e1,e2,e3"
printf "%s\n" "$(join_by ', ' ${array[*]})" # => "e1, e2, e3"
array=()
printf "%s\n" "$(join_by ',' ${array[*]})"  # => ""

# Add element to array
declare -a array1=("a" "b")
array1+=("c")
echo "${array1[@]}"  # => a b c

# Concatenate arrays
array1=("a" "b")
declare -a array2=("c" "d")
declare -a array3=("${array1[@]}" "${array2[@]}")
echo "${array3[@]}"  # => a b c d
```

> Don't use the option "set -u". This option may causes problems with empty arrays.

## Using hash tables

```bash
#!/usr/bin/env bash

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

if [ ! ${array_map["key3"]+_} ]; then
  echo "The entry key3 is not set"
else
  echo "The entry key3 is set"
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

if [ "${array_map["unexpected_key"]+_}" ]; then
  echo "The entry unexpected_key is set"
else
  echo "The entry unexpected_key is not set"
fi # => The entry unexpected_key is not set

if [ ! ${array_map["unexpected_key"]+_} ]; then
  echo "The entry unexpected_key is not set"
else
  echo "The entry unexpected_key is set"
fi # => The entry unexpected_key is not set

if [ ! "${array_map["unexpected_key"]+_}" ]; then
  echo "The entry unexpected_key is not set"
else
  echo "The entry unexpected_key is set"
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

> Don't use the option "`set -u`". This option causes problems with empty hash maps.

## Hash map with (clean) indented multiline values

```bash
#!/usr/bin/env bash

# Declare the hash map
declare -A hash=(
    [key 1]=$'\n'\
'          'line1$'\n'\
'          'line1$'\n'\
'          'line3
    [key 2]=$'\n'\
'          '"line 4"$'\n'\
'          '"line 5"$'\n'\
'          '"line 6"
)

# Convert the values of keys into arrays, and print the resulting array
printf "key 1 => [%s]\n" "${hash[key 1]}"
printf "key 2 => [%s]\n" "${hash[key 2]}"
```

Result:

```
key 1 => [
          line1
          line1
          line3]
key 2 => [      
          line 4
          line 5
          line 6]
```

> Please note that you can easily trim the elements of the hash. See next section "Hash map with arrays as values".

## Hash map with arrays as values

```bash
#!/usr/bin/env bash

# Declare the hash map
declare -A hash=(
    [key 1]=$'\n'\
'          'line1$'\n'\
'          'line1$'\n'\
'          'line3
    [key 2]=$'\n'\
'          '"line 4"$'\n'\
'          '"line 5"$'\n'\
'          '"line 6"
)

# Convert the values of keys into arrays, and print the resulting array
declare -a array1=()
printf "key 1 => [%s]\n" "${hash[key 1]}"
while IFS= read -r element; do
  element=$(echo "${element}" | sed -E 's/^\s+//; s/\s+$//')
  if [ -z "${element}" ]; then continue; fi
  array1+=("${element}")
done <<<"${hash[key 1]}"

echo "array1:"
for element in "${array1[@]}"; do
  printf "   [%s]\n" "${element}"
done

declare -a array2=()
printf "key 2 => [%s]\n" "${hash[key 2]}"
while IFS= read -r element; do
  element=$(echo "${element}" | sed -E 's/^\s+//; s/\s+$//')
  if [ -z "${element}" ]; then continue; fi
  array2+=("${element}")
done <<<"${hash[key 2]}"

echo "array2:"
for element in "${array2[@]}"; do
  printf "   [%s]\n" "${element}"
done
```

Result:

```
key 1 => [
          line1
          line1
          line3]
array1:
   [line1]      
   [line1]      
   [line3]      
key 2 => [      
          line 4
          line 5
          line 6]
array2:
   [line 4]
   [line 5]
   [line 6]
```

## Hash map with hash maps as values

```bash
#!/usr/bin/env bash

## Declare the hash map
declare -rA hash=(
    [key 1]=$'\n'\
'          '"start: cmd1"$'\n'\
'          '"stop:  cmd2"
    [key 2]=$'\n'\
'          '"start: cmd3"$'\n'\
'          '"stop:  cmd4"
)

# Process the hash map (produce 2 hash maps)
declare -A all_starts=()
declare -A all_stops=()
declare -i got_start got_stop

for key in "${!hash[@]}"; do
  got_start=0
  got_stop=0
  value="${hash[$key]}"

  while IFS= read -r line; do
    line=$(echo "${line}" | sed -E 's/^\s+//; s/\s+$//')
    if [ -z "${line}" ]; then continue; fi
    action=$(echo "${line}" | sed -E 's/^((start|stop)\s*:.*)$/\2/i')
    action="${action,,}" # convert in lowercase

    if [ "${action}" != "start" ] && [ "${action}" != "stop" ]; then
      printf "ERROR: unexpected action \"%s\"" "${action}"
      exit 1
    fi

    command=$(echo "${line}" | sed -E 's/^((start|stop)\s*:\s*(.+))$/\3/i')
    printf "(%s) => (%s)\n" "${action}" "${command}"
    if [ "${action}" == "start" ]; then
      all_starts["${key}"]="${command}"
      got_start=1
    else
      all_stops["${key}"]="${command}"
      got_stop=1
    fi
  done <<<"${value}"

  if (( got_start == 0 )) || (( got_stop == 0 )); then
    printf "ERROR: invalid value for key \"%s\"" "${key}"
  fi
done

# Print the result of the previous treatment
echo "START:"
for key in "${!all_starts[@]}"; do
  printf "   [%s] => [%s]\n" "${key}" "${all_starts["${key}"]}"
done

echo "STOP:"
for key in "${!all_stops[@]}"; do
  printf "   [%s] => [%s]\n" "${key}" "${all_stops["${key}"]}"
done
```

Result:

```
(start) => (cmd3)
(stop) => (cmd4)
(start) => (cmd1)
(stop) => (cmd2)
START:              
   [key 2] => [cmd3]
   [key 1] => [cmd1]
STOP:              
   [key 2] => [cmd4]
   [key 1] => [cmd2]
```

You can simplify a litle bit:

```bash
#!/usr/bin/env bash

# Just as an explanation
text="a b c d"
IFS=' ' read -r -a array <<< "${text}"
for e in "${array[@]}"; do
  printf "[%s]\n" "${e}"
done

## Declare the hash map
declare -rA hash=(
    [key 1]=\
'            start: cmd1'~\
'            stop:  cmd2'
    [key 2]=\
'            start: cmd3'~\
'            stop:  cmd4'
)

declare -A all_starts=()
declare -A all_stops=()
declare -i got_start got_stop

for key in "${!hash[@]}"; do
  got_start=0
  got_stop=0
  value="${hash[$key]}"

  value=$(echo "${value}" | sed -E 's/^\s+//; s/\s+$//; s/~\s+/~/g')
  IFS='~' read -r -a lines <<< "${value}"

  for line in "${lines[@]}"; do
    line=$(echo "${line}" | sed -E 's/^\s+//; s/\s+$//')
    if [ -z "${line}" ]; then continue; fi
    action=$(echo "${line}" | sed -E 's/^((start|stop)\s*:.*)$/\2/i')
    action="${action,,}" # convert in lowercase

    if [ "${action}" != "start" ] && [ "${action}" != "stop" ]; then
      printf "ERROR: unexpected action \"%s\"" "${action}"
      exit 1
    fi

    command=$(echo "${line}" | sed -E 's/^((start|stop)\s*:\s*(.+))$/\3/i')
    printf "(%s) => (%s)\n" "${action}" "${command}"
    if [ "${action}" == "start" ]; then
      all_starts["${key}"]="${command}"
      got_start=1
    else
      all_stops["${key}"]="${command}"
      got_stop=1
    fi
  done <<<"${value}"

  if (( got_start == 0 )) || (( got_stop == 0 )); then
    printf "ERROR: invalid value for key \"%s\"" "${key}"
  fi
done

# Print the result of the previous treatment
echo "START:"
for key in "${!all_starts[@]}"; do
  printf "   [%s] => [%s]\n" "${key}" "${all_starts["${key}"]}"
done

echo "STOP:"
for key in "${!all_stops[@]}"; do
  printf "   [%s] => [%s]\n" "${key}" "${all_stops["${key}"]}"
done
```

## Using SED for current operations

First, you should always activate the use of extended regular expressions (using the option `-E`).

Then, if you want to use the characters `\t`, `\r`, `\n`..., you must use this syntax:

```bash
printf "a,b,c\n" | sed -E $'s/,/\t/g'
```

> Please note the use of `$`. On bash `$'string'` causes "ANSI-C expansion" (see [this post](https://stackoverflow.com/questions/2610115/why-is-sed-not-recognizing-t-as-a-tab)).


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

### Trim a string

```bash
echo "  this is a text  " | sed -E 's/^\ +//; s/\ +$//'
```

For example:

```bash
printf "[%s]" "$(echo "  this is a text  " | sed -E 's/^\ +//; s/\ +$//')"  # => [this is a text]
```

### And what about Mac OS

Under Mac OS, some metacharacters are not recognised. This is the case for `\s`, for example.

The example below works on Mac OS:

```bash
input=$(cat <<"EOS"
# This is a comment
RemProcess = process243 10.52.144.8:14016 10.52.144.9:14016 # comment
RemProcess=process206    10.52.144.8:14016    10.52.144.9:14016    #  comment
RemProcess =process156 10.52.144.8:14016 10.52.144.9:14016 # 
RemProcess= process134 10.52.144.8:14016 10.52.144.9:14016 # 

 RemProcess = process243 10.52.144.8:14016 10.52.144.9:14016 # 
  RemProcess=process206    10.52.144.8:14016    10.52.144.9:14016    #  comment
   RemProcess =process156 10.52.144.8:14016 10.52.144.9:14016 #  comment
    RemProcess= process134 10.52.144.8:14016 10.52.144.9:14016 # 
EOS
)

IP="10\\.52\\.144\\.8"
NEW_IP="10.10.10.10"

echo "$input" | sed -E "s/^([[:blank:]]*)(RemProcess[[:blank:]]*=[[:blank:]]*process[[:digit:]]+[[:blank:]]+)${IP}(:[[:digit:]]+[[:blank:]]+[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+:[[:digit:]]+[[:blank:]]*#.+)\$/\\2${NEW_IP}\\3/"


input=$(cat <<"EOS"
# This is a comment
RemProcess = process243 10.52.144.8:14016 10.52.144.9:14016 # F147.33480.002.Castelnau-De-Médoc ICOV BAT CAS
RemProcess=process206    10.52.144.8:14016    10.52.144.9:14016    # F147.FR.33000.002.PASTEUR ICOV BAT PAS
RemProcess =process156 10.52.144.8:14016 10.52.144.9:14016 # F147.FR.33120.001.ARCACHON ICOV BAT ARC
RemProcess= process134 10.52.144.8:14016 10.52.144.9:14016 # F147.FR.33140.013.VILLENAVE D ORNON ICOV BAT VNO

 RemProcess = process243 10.52.144.8:14016 10.52.144.9:14016 # F147.33480.002.Castelnau-De-Médoc ICOV BAT CAS
  RemProcess=process206    10.52.144.8:14016    10.52.144.9:14016    # F147.FR.33000.002.PASTEUR ICOV BAT PAS
   RemProcess =process156 10.52.144.8:14016 10.52.144.9:14016 # F147.FR.33120.001.ARCACHON ICOV BAT ARC
    RemProcess= process134 10.52.144.8:14016 10.52.144.9:14016 # F147.FR.33140.013.VILLENAVE D ORNON ICOV BAT VNO
EOS
)

IP="10\\.52\\.144\\.9"
NEW_IP="10.10.10.10"
echo "$input" | sed -E "s/^([[:blank:]]*)(RemProcess[[:blank:]]*=[[:blank:]]*process[[:digit:]]+[[:blank:]]+[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+:[[:digit:]]+[[:blank:]]+)${IP}(:[[:digit:]]+[[:blank:]]*#.+)$/\\2${NEW_IP}\\3/"
```

> Good link: [sed matching whitespace on macOS](https://www.ojisanseiuchi.com/2020/08/13/sed-matching-whitespace-on-macos/)

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

## Test in numeric context

Use `(( ... ))`.

Example:

```bash
#!/usr/bin/env bash

declare -ri TRUE=1 FALSE=0
declare -ri SUCCESS=0

# -----------------------------------------

true
if (( $? == SUCCESS )); then
  echo "Success"
else
  echo "Failure"
fi # => Success

true
if (( $? != SUCCESS )); then
  echo "Failure"
else
  echo "Success"
fi # => Success

# -----------------------------------------

false
if (( $? == SUCCESS )); then
  echo "Success"
else
  echo "Failure"
fi # => Failure

false
if (( $? != SUCCESS )); then
  echo "Failure"
else
  echo "Success"
fi # => Failure

# -----------------------------------------

function is_odd {
  declare -ri value=$1
  declare -i v
  v=$(awk -v value="${value}" 'BEGIN { printf("%d\n", value%2) }')
  if ((v == 0)); then
    echo ${TRUE}
  else
    echo ${FALSE}
  fi
}

value=4
if (( $(is_odd $value) == TRUE )); then
  echo "${value} is odd"
else
  echo "${value} is not odd"
fi # 4 is odd

if (( $(is_odd $value) == FALSE )); then
  echo "${value} is not odd"
else
  echo "${value} is odd"
fi # 4 is odd

value=5
if (( $(is_odd $value) == TRUE )); then
  echo "${value} is odd"
else
  echo "${value} is not odd"
fi # 5 is not odd

if (( $(is_odd $value) == FALSE )); then
  echo "${value} is not odd"
else
  echo "${value} is odd"
fi # 5 is not odd

# -----------------------------------------

declare -ra array=("a" "b" "c")

if (( ${#array[@]} == 3 )); then
  echo "array has 3 elements"
fi # => array has 3 elements

if (( ${#array[@]} == 2 )); then
  echo "array has 2 elements"
else
  echo "array does not have 2 elements"
fi # => array does not have 2 elements
```

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
# ----------------------------------------------------
# Bookmarks
#
# create a bookmark entry:    bm /var/log log
# go to a bookmark entry:     goto @log
# list all bookmark entries:  bmls
#
# Make sure that the directory "~/.bookmarks" exists.
# ----------------------------------------------------

if [ -d "${HOME}/.bookmarks" ]; then
    export CDPATH=".:${HOME}/.bookmarks:/"
    alias goto="cd -P"
    _goto() {
        local IFS=$'\n'
        COMPREPLY=($(compgen -W "$(/bin/ls ~/.bookmarks)" -- ${COMP_WORDS[COMP_CWORD]}))
    } && complete -F _goto goto
fi

# Create a bookmark entry.
#
# Example: bm /var/log log
#          Then use "goto @log" to go to the location
#          pointed by "log".
#
# @param $1 the path to the target directory.
# @param $2 the name of the entry.
bm() {
    local -r target="${1}"
    local -r entry_name="${2}"

    if [ ! -d "${target}" ]; then
        printf "Target \"%s\" is not a directory!\n" "${target}"
        return
    fi

    local -r entry_path="${HOME}/.bookmarks/@${entry_name}"

    local go="yes"
    # Is the entry already set?
    if [ -L "${entry_path}" ]; then
      printf "The bookmark \"%s\" is already set.\n" "${entry_name}"
      local response
      while true; do
          read -p "Do you want to override the bookmark (y/n)? " response
          case $response in
              [Yy]* ) rm -f "${entry_path}"
                      break;;
              [Nn]* ) go="no"
                      break;;
              * ) echo "Please answer \"y\" or \"n\".";;
          esac
      done
    fi

    if [ "${go}" == "yes" ]; then
      ln -s "${target}" "${entry_path}"
      printf "Bookmark \"%s\" created (-> \"%s\").\n" "${entry_name}" "${target}"
    else
      echo "Operation aborted"
    fi
}

# List bookmarks entries.
bmls() {
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

declare -i a=1 b=2
printf "a+b=%d\n" $((a+b)) # => 3
printf "a-b=%d\n" $((a-b)) # => -1
printf "a*b=%d\n" $((a*b)) # => 2
```

But be careful !!!

```bash
declare -i a=1 b=2
printf "a/b=%f\n" $((a/b))        # => 0,000000 !!!
printf "a/b=%f\n" $(expr $a / $b) # => 0,000000 !!!
a=4; b=2
printf "a/b=%f\n" $((a/b))        # => 2,000000
```

If you want to do a real calculus, you can use `awk`

```bash
awk -v a=1 -v b=2 'BEGIN { printf("%f\n", a/b) }'      # => 0.500000
awk -v a=1 -v b=2 'BEGIN { printf("%f\n", log(a/b)) }' # => -0.693147
awk -v a=1 -v b=2 'BEGIN { printf("%f\n", cos(a/b)) }' # => 0.877583
awk -v a=1 -v b=2 'BEGIN { printf("%d\n", 10 % 3) }'   # => 1
awk -v a=1 -v b=2 'BEGIN { printf("%d\n", 10^3) }'     # => 1000
```

# Is string length limited ?

Response: no

let's test...

```bash
#!/usr/bin/env bash

declare -ri NUMBER_OF_KB=100
declare -i length

length=$(perl -e "print 'a' x (1024) x ${NUMBER_OF_KB}" | wc -c)
if ((length != $((1024 * NUMBER_OF_KB)) )); then
  printf "ERROR: expected %d (got %d)!" $((1024 * NUMBER_OF_KB)) "${length}"
  exit 1
else
  printf "OK: %d\n" "${length}"
fi

# Make sure that a string can be huge.
text=$(perl -e "print 'a' x (1024) x ${NUMBER_OF_KB}")
length=${#text}
if ((length != $((1024 * NUMBER_OF_KB)) )); then
  printf "ERROR: expected %d (got %d)!" $((1024 * NUMBER_OF_KB)) "${length}"
  exit 1
else
  printf "OK: %d\n" "${length}"
fi
```

# Extract a single line from a file

```bash

function trim_ctrl_m_mac {
  sed -E "s/$(printf '\r')//g"
}

function trim_ctrl_m_linux {
  sed -E "s/\r//g"
}

# Read the Nth line of a file.
# Note: comments and empty lines are ignored.
# @param $1 The path to the file.
# @param $2 The line number.
# @return The read line.

function read_line_from_file {
  local -r _in_file="${1}"
  local -ri _in_line_number="${2}"
  # Under Mac, you may need to replace "trim_ctrl_m_linux" by "trim_ctrl_m_mac".
  local -r _line=$(cat "${_in_file}" | sed -E '/^\s*#/d; /^[\s\r]*$/d' | sed -n ${_in_line_number}p  | trim_ctrl_m_linux)
  echo -n "${_line}"
}

# Usage

readonly PASS_FILE='.pass'
APIKEY_PUBLIC=$(read_line_from_file "${PASS_FILE}" 1)
APIKEY_PRIVATE=$(read_line_from_file "${PASS_FILE}" 2)
readonly APIKEY_PUBLIC
readonly APIKEY_PRIVATE
```

> * Lines that start with `#` are ignored.
> * Empty lines are ignored.

# Request a REST API

Template:

```bash
function get_one_batch_of_emails {
  local -ri _in_message_status="${1}"
  local -ri _in_limit="${2}"
  local -ri _in_offset="${3}"

  local -r _response=$(curl -s \
        -X GET \
        --user "${APIKEY_PUBLIC}:${APIKEY_PRIVATE}" \
        ${URL_GET_MESSAGES}/MessageStatus=${_in_message_status}\&ShowSubject=true\&ShowContactAlt=true\&Limit=${_in_limit}\&Offset=${_in_offset})
  echo -n "${_response}"
}

# Usage

response=$(get_one_batch_of_emails ${message_status} ${limit} ${offset})
```

# Find files

```bash
#!/bin/bash

files="tablebin.ssv
tablebin.ssp
scripts.ssv
scripts.sms
tablebin.smc
libjs64.so
libjs.so
libsmclux64.so
libsmclux.so
libsmslux64.so
libsmslux.so
libssvlux64.so
libssvlux.so
unixdef.h
log4crc.xml
libsgdlux.so
libsgdlux64.so
srt.h
libsrtlux.so
libsrtlux64.so
sts.h
scriptsi.sts
scriptsm.sts
tablesi.sts
libsts4lux.so
libsts4lux64.so
libsts8lux.so
libsts8lux64.so
libstsmlux.so
libstsmlux64.so
libstsrlux.so
libstsrlux64.so
libstsulux.so
libstsulux64.so
libstslux.so
libstslux64.so"

while IFS= read -r file; do
  printf "Search for \"%s\"\n" "${file}"
  find /opt/santesocial/fsv/1.40.14 -type f -name "${file}" -print  -exec false {} +
  if [[ $? == 0 ]]; then 
    printf "[N] %s is NOT present\n" "${file}"
  else 
    printf "[Y] %s is present\n" "${file}"
  fi
  echo
done <<< "${files}"
```

