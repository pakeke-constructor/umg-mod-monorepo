
local entityHelper = require("shared.entity_helper")

local base = {
    gravity = require("shared.gravity");
    
    Class = require("shared.class");
    Set = require("shared.set");
    Array = require("shared.array");
    Heap = require("shared.heap");
    Partition = require("shared.partition.partition");

    physics = require("server.physics");
    
    getPlayer = require("shared.get_player");

    entityHelper = entityHelper;

    weightedRandom = require("shared.weighted_random");

    inspect = require("_libs.inspect");

    delay = require("shared.delay")
}


export("base", base)


