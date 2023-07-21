
--[[

base mod API export 


]]

local defineExports = require("shared.define_exports")



local function loadClientRendering(base)
    --[[
        
        (all of this stuff has been exported to rendering mod)

    ]]
    local draw = require("client.draw")
    local drawEntities = require("client.draw_entities")
    local animate = require("client.animate")
    local camera = require("client.camera")
    
    base.client.camera = camera;

    base.client.isHovered = require("client.mouse_hover")
    
    base.client.getUIScale = draw.getUIScale

    -- TODO: Are these functions used?
    base.client.setUIScale = draw.setUIScale
    base.client.getUIMousePosition = draw.getUIMousePosition

    base.client.isOnScreen = drawEntities.isOnScreen
    base.client.entIsOnScreen = drawEntities.entIsOnScreen

    base.client.drawEntity = drawEntities.drawEntity

    base.client.getDrawY = drawEntities.getDrawY;
    base.client.getDrawDepth = drawEntities.getDrawDepth;


    base.client.drawStats = require("client.image_helpers.draw_stats")
    -- ^^^ this has been renamed to `getEntityProperties`

    base.client.getQuadOffsets = require("client.image_helpers.quad_offsets");
    -- ^^^ This has been renamed to `getImageOffsets`

    base.client.drawImage = require("client.image_helpers.draw_image");

    base.client.animate = animate.animate;
    base.client.animateEntity = animate.animateEntity;
end


local function loadClient(base)
    base.client = {}

    --loadClientRendering()

    base.client.groundTexture = require("client.ground_texture")


    local control = require("client.control")
    base.client.control = control -- TODO: Should we remove this API? It's kinda weird.
    -- (actually, its doing nothing)

    local shockwave = require("client.shockwaves")
    base.client.shockwave = shockwave;

    base.client.particles = require("client.particles");

    base.client.popups = require("client.popups")

    base.client.sound = require("client.sound")

    base.client.title = require("client.title");
end


local function loadShared(base)
    base.gravity = require("shared.gravity");

    base.initializers = require("shared.initializers")
    base.operators = require("shared.operators")
    
    base.getGameTime = require("shared.get_game_time")
    
    base.components = require("shared.components")

    base.delay = require("shared.delay").delay;
    base.nextTick = require("shared.delay").nextTick;
    base.inspect = require("_libs.inspect");

    base.weightedRandom = require("shared.weighted_random");
    
    base.getPlayer = require("shared.get_player");

    base.physics = require("shared.physics")

    base.runEvery = require("shared.run_every")

    base.defineExports = defineExports
end



local function loadServer(base)
    local controlAdmin = require("server.control_admin")
    
    base.server = {}
    
    -- TODO: move to `mortality` mod
    base.server.kill = require("shared.death")
    base.server.forceSetPlayerPosition = controlAdmin.forceSetPlayerPosition 
end



defineExports({
    name = "base",
    loadServer = loadServer,
    loadClient = loadClient,
    loadShared = loadShared
})


