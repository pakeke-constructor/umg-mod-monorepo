
--[[

base export table

]]

local draw = require("client.draw")

local shockwave = require("client.shockwaves")

local sound = require("client.sound")

local entityHelper = require("shared.entity_helper")

local animate = require("client.animate")



local base = {
    camera = draw.camera;

    isHovered = require("client.mouse_hover");

    physics = require("client.physics");

    getUIScale = draw.getUIScale;
    setUIScale = draw.setUIScale;

    isOnScreen = draw.isOnScreen;
    entOnScreen = draw.entOnScreen;

    getDrawY = draw.getDrawY;
    getDrawDepth = draw.getDrawDepth;

    getQuadOffsets = require("client.image_helpers.quad_offsets");
    drawImage = require("client.image_helpers.draw_image");

    animate = animate.animate;
    animateEntity = animate.animateEntity;

    shockwave = shockwave;

    gravity = require("shared.gravity");

    Class = require("shared.class");
    Set = require("shared.set");
    Array = require("shared.array");
    Heap = require("shared.heap");
    Partition = require("shared.partition.partition");
    
    getPlayer = require("shared.get_player");

    particles = require("client.particles");

    playSound = sound.playSound;
    playMusic = sound.playMusic;

    entityHelper = entityHelper;

    weightedRandom = require("shared.weighted_random");

    inspect = require("_libs.inspect");

    title = require("client.title");

    delay = require("shared.delay")
}




export("base", base)

