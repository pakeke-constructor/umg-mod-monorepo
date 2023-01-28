
--[[

base mod API export 


]]

local defineExports = require("shared.define_exports")



local function loadClient(base)
    local draw = require("client.draw")
    local shockwave = require("client.shockwaves")
    local sound = require("client.sound")
    local animate = require("client.animate")
    local input = require("client.input")
    
    base.camera = draw.camera;

    base.input = input
    
    base.isHovered = require("client.mouse_hover")
    
    base.physics = require("client.physics")

    base.getUIScale = draw.getUIScale
    base.setUIScale = draw.setUIScale

    base.isOnScreen = draw.isOnScreen
    base.entOnScreen = draw.entOnScreen

    base.getDrawY = draw.getDrawY;
    base.getDrawDepth = draw.getDrawDepth;

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

    base.components = require("shared.components")

    base.delay = require("shared.delay")
    base.inspect = require("_libs.inspect");

    base.weightedRandom = require("shared.weighted_random");
    
    base.getPlayer = require("shared.get_player");

    base.typecheck = require("shared.typecheck")

    base.defineExports = defineExports
end



local function loadServer(base)
    base.physics = require("server.physics");
end



defineExports({
    name = "base",
    loadServer = loadServer,
    loadClient = loadClient,
    loadShared = loadShared
})


