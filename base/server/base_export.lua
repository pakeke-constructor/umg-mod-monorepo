
local entityHelper = require("other.entity_helper")

local base = {
    gravity = require("other.gravity");
    
    Class = require("other.class");
    Set = require("other.set");
    Array = require("other.array");
    Heap = require("other.heap");
    Partition = require("other.partition.partition");
    
    getPlayer = require("other.get_player");

    entityHelper = entityHelper;

    weightedRandom = require("other.weighted_random");

    inspect = require("_libs.inspect");

    delay = require("other.delay")
}


export("base", base)


