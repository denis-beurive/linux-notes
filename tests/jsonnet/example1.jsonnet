// example1.jsonnet
// jsonnet example1.jsonnet

local haspmap = { k1: 'v1', k2: 'v2' };

{
	keys: [ key for key in std.objectFields(haspmap) ]
}