
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


    shockwave = shockwave
}




export("base", base)

