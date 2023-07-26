
local visualfx = {}


local shockwave = require("client.shockwaves")
visualfx.shockwave = shockwave;

visualfx.particles = require("client.particles");

visualfx.popups = require("client.popups")

visualfx.title = require("client.title");


umg.expose("visualfx", visualfx)

