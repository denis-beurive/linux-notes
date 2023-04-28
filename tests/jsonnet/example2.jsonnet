// example2.jsonnet
// jsonnet example2.jsonnet

local haspmap = { k1: 'v1', k2: 'v2' };

{ [key + "0"]: haspmap[key] for key in std.objectFields(haspmap) }

