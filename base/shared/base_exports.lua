
--[[

base mod API export 


]]

local defineExports = require("shared.define_exports")


local function loadClient(base)
    base.client = {}

    base.client.groundTexture = require("client.ground_texture")
end


local function loadShared(base)
    base.gravity = require("shared.gravity");

    base.initializers = require("shared.initializers")
    
    base.components = require("shared.components")

    base.delay = require("shared.delay").delay;
    base.nextTick = require("shared.delay").nextTick;

    base.inspect = require("_libs.inspect");

    base.weightedRandom = require("shared.weighted_random");
    
    base.getPlayer = require("shared.get_player");

    -- removed!
    -- base.physics = require("shared.physics")

    base.runEvery = require("shared.run_every")

    base.defineExports = defineExports
end



local function loadServer(base)
    base.server = {}
end



defineExports({
    name = "base",
    loadServer = loadServer,
    loadClient = loadClient,
    loadShared = loadShared
})


