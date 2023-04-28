# JSONNET

## Array comprehensions

```jsonnet
// example1.jsonnet
// jsonnet example1.jsonnet

local haspmap = { k1: 'v1', k2: 'v2' };

{
	keys: [ key for key in std.objectFields(haspmap) ]
}
```

```bash
$ jsonnet example1.jsonnet
{
   "keys": [
      "k1",
      "k2"
   ]
}
```

## Hashmap comprehensions

```jsonnet
// example2.jsonnet
// jsonnet example2.jsonnet

local haspmap = { k1: 'v1', k2: 'v2' };

{ [key + "0"]: haspmap[key] for key in std.objectFields(haspmap) }
```

> Please note the `[` and `]` around the variable's name that represents the key.

```bash
$ jsonnet example2.jsonnet
{
   "k10": "v1",
   "k20": "v2"
}
```

## Meging objects

```jsonnet
// example3.jsonnet
// jsonnet example3.jsonnet

local haspmap1 = { k1: 'v1', k2: 'v2' };
local haspmap2 = { k3: 'v3', k4: 'v4' };

std.mergePatch(haspmap1, haspmap2)
```

```bash
$ jsonnet example3.jsonnet
{
   "k1": "v1",
   "k2": "v2",
   "k3": "v3",
   "k4": "v4"
}
```

