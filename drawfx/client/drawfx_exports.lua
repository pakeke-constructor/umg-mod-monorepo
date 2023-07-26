
local drawfx = {}


local shockwave = require("client.shockwaves")
drawfx.shockwave = shockwave;

drawfx.particles = require("client.particles");

drawfx.popups = require("client.popups")

drawfx.title = require("client.title");


umg.expose("drawfx", drawfx)

