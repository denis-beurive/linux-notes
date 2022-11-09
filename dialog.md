# Using dialog to create console menus

The following script shows how to create a menu used to select items.

```bash
#!/usr/bin/env bash

# Be careful: the command is represented by an array:
# Why? Just because the syntax "$(list)", used to run a subshell needs a list (that is, an array, not a string).

function form1 {
  # Please note that we execute a subshell with the syntax "$(list)". What's inside the parentheses is an array!
  # The variable "choices" is a string.
  declare -r choices=$(dialog --stdout --no-items --separate-output --ok-label "Delete" --checklist "Select options:" 22 76 16 'p1' 'on' 'p2' 'on')

  # The variable "choices" is a string. Let's build an array from this string.
  declare -a result=()
  local choice
  while IFS= read -r choice; do
      result+=("${choice}")
  done <<<"${choices}"

  # Print the elements of the array that contains the selected values.
  local token
  for token in "${result[@]}"; do
    printf -- "   - \"%s\"\n" "${token}"
  done
}

function form2 {
  # The list defined in the previous example is defined outside of the subshell execution.
  declare -ra command=(dialog --clear --stdout --no-items --separate-output --ok-label "Delete" --checklist "Select options:" 22 76 16 'p1' 'on' 'p2' 'on')
  printf "The array \"cmd\" contains %s elements:\n" ${#command}
  local token
  for token in "${command[@]}"; do
    printf -- "   - \"%s\"\n" "${token}"
  done
  declare -r choices=$("${command[@]}")
  echo "${choices}"
}

function form3 {
  # This is identical to the previous example, except that we only predefined part of the list (that represents the
  # shell command executed within the subshell). Extra parameters are given later.
  declare -ra command=(dialog --clear --stdout --no-items --separate-output --ok-label "Delete" --checklist "Select options:" 22 76 16)
  declare -r choices=$("${command[@]}" 'p1' 'on' 'p2' 'on')
  echo "${choices}"
}

function form4 {
  # This is identical to the previous example, except that the list is represented "vertically".
  declare -ra command3=(dialog \
                        --clear \
                        --stdout \
                        --no-items \
                        --separate-output \
                        --ok-label "Delete" \
                        --checklist "Select options:" 22 76 16)
  declare -r choices=$("${command3[@]}" 'p1' 'on' 'p2' 'on')
  echo "${choices}"
}

form1
form2
form3
form4
```

