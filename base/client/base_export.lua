
--[[

base export table

]]

local draw = require("client.draw")

local shockwave = require("client.shockwaves")

local sound = require("client.sound")

local entityHelper = require("other.entity_helper")

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

    gravity = require("other.gravity");

    Class = require("other.class");
    Set = require("other.set");
    Array = require("other.array");
    Heap = require("other.heap");
    Partition = require("other.partition.partition");
    
    getPlayer = require("other.get_player");

    particles = require("client.particles");

    playSound = sound.playSound;
    playMusic = sound.playMusic;

    entityHelper = entityHelper;

    weightedRandom = require("other.weighted_random");

    inspect = require("_libs.inspect");

    title = require("client.title");

    delay = require("other.delay")
}




export("base", base)

