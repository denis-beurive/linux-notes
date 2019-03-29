# Bash

## Path to the current script



## Heredoc with substitutions

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

Result:

    V1=10
    V2=20
    V3="${V3}"

## Local variable into functions

Use the keyword "`local`":

    #!/bin/bash

    function func {
        local mylocal=10
        echo "In the function: mylocal = ${mylocal}"
    }

    func

    echo "Outside the function: mylocal = ${mylocal}"

Result:

    In the function: mylocal = 10
    Outside the function: mylocal = 

If you remove the keyword "`local`", then the variable `mylocal` is not local to the function anymore. Let's make the test:

    #!/bin/bash

    function func {
        mylocal=10 ### No "local" here !!!
        echo "In the function: mylocal = ${mylocal}"
    }

    func

    echo "Outside the function: mylocal = ${mylocal}"

Result:

    In the function: mylocal = 10
    Outside the function: mylocal = 10

## Local and readonly

Use `local -r`. For example:

    #!/bin/bash

    function my_function {
        local -r variable=10
        echo ${variable}
    }
    my_function

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


