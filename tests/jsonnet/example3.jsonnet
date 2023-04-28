// example3.jsonnet
// jsonnet example3.jsonnet

local haspmap1 = { k1: 'v1', k2: 'v2' };
local haspmap2 = { k3: 'v3', k4: 'v4' };

std.mergePatch(haspmap1, haspmap2)