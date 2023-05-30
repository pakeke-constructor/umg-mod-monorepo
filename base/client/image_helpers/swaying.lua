
local getQuadOffsets = require("client.image_helpers.quad_offsets")


local sin = math.sin

local tick = 0

local BIG = 0xffffff

umg.on("gameUpdate", function(dt)
    tick = (tick + dt) % BIG
end)


local DEFAULT_SWAY_PERIOD = 3
local DEFAULT_SWAY_MAGNITUDE = 0.3

local PI2 = math.pi * 2

local POSSIBLE_OFFSETS = 51 -- this is arbitrary


local function getSwayFactor(ent)
    local swaying = ent.swaying
    local period = swaying.period or DEFAULT_SWAY_PERIOD
    
    -- divide magnitude by 2 to give amplitude of sine wave
    local mag = swaying.magnitude or DEFAULT_SWAY_MAGNITUDE / 2

    local sin_offset = (ent.id % POSSIBLE_OFFSETS) / period

    local sway_factor = mag * sin(tick * PI2 / period + sin_offset)
    return sway_factor
end


umg.answer("getOffsetX", function(ent)
    if ent.swaying then
        local ox, _oy = getQuadOffsets(ent.image)
        local quad_width = ox * 2
        local sway_factor = getSwayFactor(ent)
        return quad_width * sway_factor
    end
    return 0
end)


umg.answer("getShearX", function(ent)
    if ent.swaying then
        local sway_factor = getSwayFactor(ent)
        return sway_factor
    end
end)

