
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
    local input = require("client.input")
    local camera = require("client.camera")
    local control = require("client.control")
    
    base.client.camera = camera;

    base.client.input = input
    base.client.control = control -- TODO: Should we remove this API? It's kinda weird.
    
    base.client.isHovered = require("client.mouse_hover")
    
    base.client.getUIScale = draw.getUIScale
    base.client.setUIScale = draw.setUIScale

    base.client.isOnScreen = drawEntities.isOnScreen
    base.client.entIsOnScreen = drawEntities.entIsOnScreen

    base.client.getDrawY = drawEntities.getDrawY;
    base.client.getDrawDepth = drawEntities.getDrawDepth;

    base.client.getQuadOffsets = require("client.image_helpers.quad_offsets");
    base.client.drawImage = require("client.image_helpers.draw_image");
    
    base.client.groundTexture = require("client.ground_texture")

    base.client.animate = animate.animate;
    base.client.animateEntity = animate.animateEntity;

    base.client.shockwave = shockwave;

    base.client.particles = require("client.particles");

    base.client.playSound = sound.playSound;
    base.client.playMusic = sound.playMusic;

    base.client.title = require("client.title");
end


local function loadShared(base)
    base.gravity = require("shared.gravity");

    base.initializers = require("shared.initializers")
    
    base.getGameTime = require("shared.get_game_time")

    base.Class = require("shared.class");
    base.Set = require("shared.set");
    base.Array = require("shared.array");
    base.Heap = require("shared.heap");
    base.Partition = require("shared.partition");
    base.Enum = require("shared.enum")
    
    base.components = require("shared.components")

    base.delay = require("shared.delay")
    base.inspect = require("_libs.inspect");

    base.weightedRandom = require("shared.weighted_random");
    
    base.getPlayer = require("shared.get_player");

    base.typecheck = require("shared.typecheck")

    base.physics = require("shared.physics")

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


