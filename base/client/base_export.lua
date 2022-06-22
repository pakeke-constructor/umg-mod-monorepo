
--[[

base export table

]]

local draw = require("client.draw")

local shockwave = require("client.shockwaves")


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

}




export("base", base)

