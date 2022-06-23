
--[[

base export table

]]

local draw = require("client.draw")

local shockwave = require("client.shockwaves")

local sound = require("client.sound")



local base = {
    camera = draw.camera;

    getUIScale = draw.getUIScale;
    setUIScale = draw.setUIScale;

    isOnScreen = draw.isOnScreen;
    entOnScreen = draw.entOnScreen;

    shockwave = shockwave;

    Class = require("other.class");
    Set = require("other.set");
    Array = require("other.array");
    
    getQuadOffsets = require("client.image_helpers.quad_offsets");

    getPlayer = require("other.get_player");

    particles = require("client.particles");

    playSound = sound.playSound;
    playMusic = sound.playMusic
}




export("base", base)

