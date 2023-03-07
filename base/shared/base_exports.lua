
--[[

base mod API export 


]]

local defineExports = require("shared.define_exports")



local function loadClient(base)
    local draw = require("client.draw")
    local drawEntities = require("client.draw_entities")
    local shockwave = require("client.shockwaves")
    local sound = require("client.sound")
    local animate = require("client.animate")
    local input = require("client.input")
    local camera = require("client.camera")
    
    base.camera = camera;

    base.input = input
    
    base.isHovered = require("client.mouse_hover")
    
    base.getUIScale = draw.getUIScale
    base.setUIScale = draw.setUIScale

    base.isOnScreen = drawEntities.isOnScreen
    base.entIsOnScreen = drawEntities.entIsOnScreen

    base.getDrawY = drawEntities.getDrawY;
    base.getDrawDepth = drawEntities.getDrawDepth;

    base.getQuadOffsets = require("client.image_helpers.quad_offsets");
    base.drawImage = require("client.image_helpers.draw_image");
    
    base.groundTexture = require("client.ground_texture")

    base.animate = animate.animate;
    base.animateEntity = animate.animateEntity;

    base.shockwave = shockwave;

    base.particles = require("client.particles");

    base.playSound = sound.playSound;
    base.playMusic = sound.playMusic;

    base.title = require("client.title");
end


local function loadShared(base)
    base.gravity = require("shared.gravity");

    base.entityHelper = require("shared.entity_helper")
    
    base.getGameTime = require("shared.get_game_time")

    base.Class = require("shared.class");
    base.Set = require("shared.set");
    base.Array = require("shared.array");
    base.Heap = require("shared.heap");
    base.Partition = require("shared.partition.partition");
    base.Enum  =require("shared.enum");

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
    base.kill = require("shared.death")
end



defineExports({
    name = "base",
    loadServer = loadServer,
    loadClient = loadClient,
    loadShared = loadShared
})


