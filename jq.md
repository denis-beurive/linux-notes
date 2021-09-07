# JQ examples

## Test set

We will use this sequence of JSON inputs for illustration.

> These structures have been obtained using the script [generate_data.py](code/generate_data.py).

```
{"details": {"a": [17], "b": {"Mia": 55, "Oliver": 68}}, "note": "Very well 0 !", "results": {"Ava": 0, "Liam": 7}, "students": ["Liam", "Ava"]}
{"details": {"a": [], "b": {"Evelyn": 89}, "c": 17}, "results": {"Amelia": 5, "Elijah": 9, "Henry": 18, "Olivia": 12}, "students": ["Olivia", "Elijah", "Amelia", "Henry", "Olivia", "Elijah", "Amelia"]}
{"details": {"a": [53, 1, 17, 89, 13, 21, 57, 69, 73], "b": {"Mia": 55, "Oliver": 68}}, "results": {"Benjamin": 4, "Charlotte": 14, "Evelyn": 7, "Noah": 10}, "students": ["Noah", "Charlotte", "Benjamin", "Evelyn", "Noah", "Charlotte", "Benjamin", "Evelyn", "Noah", "Charlotte", "Benjamin", "Evelyn"]}
{"details": {"a": [], "b": {"Evelyn": 89}, "c": 17}, "note": "Very well 3 !", "results": {"Alexander": 16, "Emma": 4, "Isabella": 17, "William": 19}, "students": ["Emma", "William", "Isabella", "Alexander", "Emma", "William", "Isabella", "Alexander", "Emma", "William", "Isabella", "Alexander", "Emma", "William", "Isabella", "Alexander", "Emma"]}
{"details": {"a": [53, 1, 17, 89, 13, 21, 57, 69, 73], "b": {"Mia": 55, "Oliver": 68}}, "results": {"Oliver": 5, "Sophia": 12}, "students": ["Oliver", "Sophia"]}
{"details": {"a": [], "b": {"Evelyn": 89}, "c": 17}, "results": {"Ava": 0, "James": 16, "Liam": 7, "Mia": 19}, "students": ["Ava", "James", "Mia", "Liam", "Ava", "James", "Mia"]}
{"details": {"a": [53, 1, 17, 89, 13, 21, 57, 69, 73], "b": {"Mia": 55, "Oliver": 68}}, "note": "Very well 6 !", "results": {"Amelia": 5, "Elijah": 9, "Henry": 18, "Olivia": 12}, "students": ["Elijah", "Amelia", "Henry", "Olivia", "Elijah", "Amelia", "Henry", "Olivia", "Elijah", "Amelia", "Henry", "Olivia"]}
{"details": {"a": [], "b": {"Evelyn": 89}, "c": 17}, "results": {"Benjamin": 4, "Charlotte": 14, "Evelyn": 7, "Noah": 10}, "students": ["Charlotte", "Benjamin", "Evelyn", "Noah", "Charlotte", "Benjamin", "Evelyn", "Noah", "Charlotte", "Benjamin", "Evelyn", "Noah", "Charlotte", "Benjamin", "Evelyn", "Noah", "Charlotte"]}
{"details": {"a": [53, 1, 17, 89, 13, 21, 57, 69, 73], "b": {"Mia": 55, "Oliver": 68}}, "results": {"Isabella": 17, "William": 19}, "students": ["William", "Isabella"]}
{"details": {"a": [], "b": {"Evelyn": 89}, "c": 17}, "note": "Very well 9 !", "results": {"Harper": 10, "Lucas": 4, "Oliver": 5, "Sophia": 12}, "students": ["Sophia", "Lucas", "Harper", "Oliver", "Sophia", "Lucas", "Harper"]}
```

A more readable version:

```shell
python code/generate_data.py | jq
```

```
{
  "details": {
    "a": [
      17
    ],
    "b": {
      "Mia": 55,
      "Oliver": 68
    }
  },
  "note": "Very well 0 !",
  "results": {
    "Ava": 0,
    "Liam": 7
  },
  "students": [
    "Liam",
    "Ava"
  ]
}
{
  "details": {
    "a": [],
    "b": {
      "Evelyn": 89
    },
    "c": 17
  },
  "results": {
    "Amelia": 5,
    "Elijah": 9,
    "Henry": 18,
    "Olivia": 12
  },
  "students": [
    "Olivia",
    "Elijah",
    "Amelia",
    "Henry",
    "Olivia",
    "Elijah",
    "Amelia"
  ]
}
{
  "details": {
    "a": [
      53,
      1,
      17,
      89,
      13,
      21,
      57,
      69,
      73
    ],
    "b": {
      "Mia": 55,
      "Oliver": 68
    }
  },
  "results": {
    "Benjamin": 4,
    "Charlotte": 14,
    "Evelyn": 7,
    "Noah": 10
  },
  "students": [
    "Noah",
    "Charlotte",
    "Benjamin",
    "Evelyn",
    "Noah",
    "Charlotte",
    "Benjamin",
    "Evelyn",
    "Noah",
    "Charlotte",
    "Benjamin",
    "Evelyn"
  ]
}
{
  "details": {
    "a": [],
    "b": {
      "Evelyn": 89
    },
    "c": 17
  },
  "note": "Very well 3 !",
  "results": {
    "Alexander": 16,
    "Emma": 4,
    "Isabella": 17,
    "William": 19
  },
  "students": [
    "Emma",
    "William",
    "Isabella",
    "Alexander",
    "Emma",
    "William",
    "Isabella",
    "Alexander",
    "Emma",
    "William",
    "Isabella",
    "Alexander",
    "Emma",
    "William",
    "Isabella",
    "Alexander",
    "Emma"
  ]
}
{
  "details": {
    "a": [
      53,
      1,
      17,
      89,
      13,
      21,
      57,
      69,
      73
    ],
    "b": {
      "Mia": 55,
      "Oliver": 68
    }
  },
  "results": {
    "Oliver": 5,
    "Sophia": 12
  },
  "students": [
    "Oliver",
    "Sophia"
  ]
}
{
  "details": {
    "a": [],
    "b": {
      "Evelyn": 89
    },
    "c": 17
  },
  "results": {
    "Ava": 0,
    "James": 16,
    "Liam": 7,
    "Mia": 19
  },
  "students": [
    "Ava",
    "James",
    "Mia",
    "Liam",
    "Ava",
    "James",
    "Mia"
  ]
}
{
  "details": {
    "a": [
      53,
      1,
      17,
      89,
      13,
      21,
      57,
      69,
      73
    ],
    "b": {
      "Mia": 55,
      "Oliver": 68
    }
  },
  "note": "Very well 6 !",
  "results": {
    "Amelia": 5,
    "Elijah": 9,
    "Henry": 18,
    "Olivia": 12
  },
  "students": [
    "Elijah",
    "Amelia",
    "Henry",
    "Olivia",
    "Elijah",
    "Amelia",
    "Henry",
    "Olivia",
    "Elijah",
    "Amelia",
    "Henry",
    "Olivia"
  ]
}
{
  "details": {
    "a": [],
    "b": {
      "Evelyn": 89
    },
    "c": 17
  },
  "results": {
    "Benjamin": 4,
    "Charlotte": 14,
    "Evelyn": 7,
    "Noah": 10
  },
  "students": [
    "Charlotte",
    "Benjamin",
    "Evelyn",
    "Noah",
    "Charlotte",
    "Benjamin",
    "Evelyn",
    "Noah",
    "Charlotte",
    "Benjamin",
    "Evelyn",
    "Noah",
    "Charlotte",
    "Benjamin",
    "Evelyn",
    "Noah",
    "Charlotte"
  ]
}
{
  "details": {
    "a": [
      53,
      1,
      17,
      89,
      13,
      21,
      57,
      69,
      73
    ],
    "b": {
      "Mia": 55,
      "Oliver": 68
    }
  },
  "results": {
    "Isabella": 17,
    "William": 19
  },
  "students": [
    "William",
    "Isabella"
  ]
}
{
  "details": {
    "a": [],
    "b": {
      "Evelyn": 89
    },
    "c": 17
  },
  "note": "Very well 9 !",
  "results": {
    "Harper": 10,
    "Lucas": 4,
    "Oliver": 5,
    "Sophia": 12
  },
  "students": [
    "Sophia",
    "Lucas",
    "Harper",
    "Oliver",
    "Sophia",
    "Lucas",
    "Harper"
  ]
}
```

Select records that contains a given field (here `.details.c`):

```bash
python3 code/generate_data.py |
jq 'if .details.c
    then
        .
    else
        empty
    end'

# or, just:

python3 code/generate_data.py | jq 'select (.details.c)'
```

Select records that contains two given fields (here `.details.c` and `.details.b.Evelyn`):

```bash
python3 code/generate_data.py |
jq 'if .details.c and .details.b.Evelyn
    then
        .
    else
        empty
    end'

# or, just:

python3 code/generate_data.py | jq 'select (.details.c) | select (.details.b.Evelyn)' 
```

Select records that contain at least one of two given fields (here `.details.c` or `.results.Isabella`):

```bash
python3 code/generate_data.py |
jq 'if .details.c or .results.Isabella
    then
        .
    else
        empty
    end'

# or, just:

python3 code/generate_data.py | jq 'select (.details.c) | select (.results.Isabella)' 
```

Using variables in JQ expressions:

```bash
python3 code/generate_data.py |
jq '.details as $d |
    if .results.Isabella
    then
        $d
    else
        empty
    end'
```

We can include tests within tests:

```bash
python3 code/generate_data.py |
jq '.details as $d |
    if .results.Isabella
    then
        if .details.c
        then
            $d
        else
            empty
        end
    else
        empty
    end'

# or, just:

python3 code/generate_data.py | jq 'select(.results.Isabella) | select(.details.c) | .details'
```

> Please note that this expression can be simplified: python3 code/generate_data.py | jq 'select(.results.Isabella) | .details.c | .details'

Select records based on the presence of a given item in a given array. Here we select records which array `select(.details.a` contains the value `17`.


```bash
python3 code/generate_data.py | jq 'select(.details.a | index(17)) | .'

# or, just for fun:

python3 code/generate_data.py | jq '. as $v | select(.details.a | index(17)) | $v'

```

Select the "first level" keys:

```bash
python3 code/generate_data.py | jq 'keys'
```

No pretty print. Use the option `-c`:

```bash
$ python3 code/generate_data.py | jq -c 'select(.results.Isabella) | select(.details.c) | .details'
{"a":[],"b":{"Evelyn":89},"c":17}
```

> This option is useful when you need to select only a certain number of records, for example. Ex: `python3 code/generate_data.py | jq -c 'select(.results.Isabella) | select(.details.c) | .details' | tail -n 2`.

