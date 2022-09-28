

local sin = math.sin

local tick = 0

local BIG = 0xffffff

on("gameUpdate", function(dt)
    tick = (tick + dt) % BIG
end)


local DEFAULT_SWAY_PERIOD = 3
local DEFAULT_SWAY_MAGNITUDE = 0.3

local PI2 = math.pi * 2

return function(ent, ox)
    --[[
        returns the X offset, and the shear X value.
        Default is 0 and 0.
    ]]
    if ent.swaying then
        local swaying = ent.swaying
        local quad_width = ox * 2 -- as defined by quad_offsets.lua
        local period = swaying.period or DEFAULT_SWAY_PERIOD
        
        -- divide magnitude by 2 to give amplitude of sine wave
        local mag = swaying.magnitude or DEFAULT_SWAY_MAGNITUDE / 2

        local sin_offset = (ent.id % 13) / period

        local sway_mult = mag * sin(tick * PI2 / period + sin_offset)

        return quad_width * sway_mult, sway_mult
    else
        return 0, 0
    end
end

