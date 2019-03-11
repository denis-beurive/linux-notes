# Bash

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

    #!/bin/bash

    function func {
        local v=10
        echo "In the function v=$v"
    }

    func

    echo "Outside the function v=$v"

Result:

    In the function v=10
    Outside the function v=

## Immediately exit if any command has a non-zero exit status

    set -e

