
local getQuadOffsets = require("client.image_helpers.quad_offsets")


local sin = math.sin

local tick = 0

local BIG = 0xffffff

umg.on("gameUpdate", function(dt)
    tick = (tick + dt) % BIG
end)


local DEFAULT_BOB_PERIOD = 0.6
local DEFAULT_BOB_MAGNITUDE = 0.15

local PI2 = math.pi * 2

local POSSIBLE_OFFSETS = 52 -- this is arbitrary

local function getBobFactor(ent)
    local bobbing = ent.bobbing
    local period = bobbing.period or DEFAULT_BOB_PERIOD
    
    -- divide magnitude by 2 to give amplitude of sine wave
    local mag = bobbing.magnitude or DEFAULT_BOB_MAGNITUDE / 2
    local sin_offset = (ent.id % POSSIBLE_OFFSETS) / period
    local bob_factor = mag * sin(tick * PI2 / period + sin_offset)
    return bob_factor
    
    --quad_height * scale_mult, (1 + scale_mult)
end


umg.answer("getOffsetY", function(ent)
    if ent.bobbing then
        local _ox, oy = getQuadOffsets(ent)
        local quad_height = oy * 2 -- as defined by quad_offsets.lua
        local bob_factor = getBobFactor(ent)
        return quad_height * bob_factor
    end
    return 0
end)


umg.answer("getScaleY", function(ent)
    if ent.bobbing then
        local bob_factor = getBobFactor(ent)
        return 1 + bob_factor
    end
    return 1
end)

