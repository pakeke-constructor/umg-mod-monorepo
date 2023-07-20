
--[[

base mod API export 


]]

local defineExports = require("shared.define_exports")



local function loadClient(base)
    base.client = {}

    local draw = require("client.draw")
    local drawEntities = require("client.draw_entities")
    local shockwave = require("client.shockwaves")
    local sound = require("client.sound")
    local animate = require("client.animate")
    local camera = require("client.camera")
    local control = require("client.control")
    
    base.client.camera = camera;

    base.client.control = control -- TODO: Should we remove this API? It's kinda weird.
    
    base.client.isHovered = require("client.mouse_hover")
    
    base.client.getUIScale = draw.getUIScale
    base.client.setUIScale = draw.setUIScale
    base.client.getUIMousePosition = draw.getUIMousePosition

    base.client.isOnScreen = drawEntities.isOnScreen
    base.client.entIsOnScreen = drawEntities.entIsOnScreen

    base.client.drawEntity = drawEntities.drawEntity

    base.client.getDrawY = drawEntities.getDrawY;
    base.client.getDrawDepth = drawEntities.getDrawDepth;

    base.client.drawStats = require("client.image_helpers.draw_stats")

    base.client.getQuadOffsets = require("client.image_helpers.quad_offsets");
    base.client.drawImage = require("client.image_helpers.draw_image");
    
    base.client.groundTexture = require("client.ground_texture")

    base.client.animate = animate.animate;
    base.client.animateEntity = animate.animateEntity;

    base.client.shockwave = shockwave;

    base.client.particles = require("client.particles");

    base.client.Color = require("client.color")

    base.client.popups = require("client.popups")

    base.client.sound = sound

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
    base.server.kill = require("shared.death")
    base.server.forceSetPlayerPosition = controlAdmin.forceSetPlayerPosition 
end



defineExports({
    name = "base",
    loadServer = loadServer,
    loadClient = loadClient,
    loadShared = loadShared
})


