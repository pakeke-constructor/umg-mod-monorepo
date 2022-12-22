

local sin = math.sin

local tick = 0

local BIG = 0xffffff

umg.on("gameUpdate", function(dt)
    tick = (tick + dt) % BIG
end)


local DEFAULT_BOB_PERIOD = 0.6
local DEFAULT_BOB_MAGNITUDE = 0.15

local PI2 = math.pi * 2

return function(ent, oy)
    --[[
        returns the Y offset, and the Y scale multiplier for bobbing component.
        Default is 0 and 1.
    ]]
    if ent.bobbing then
        local bobbing = ent.bobbing
        local quad_height = oy * 2 -- as defined by quad_offsets.lua
        local period = bobbing.period or DEFAULT_BOB_PERIOD
        
        -- divide magnitude by 2 to give amplitude of sine wave
        local mag = bobbing.magnitude or DEFAULT_BOB_MAGNITUDE / 2

        local sin_offset = (ent.id % 52) / period

        local scale_mult = mag * sin(tick * PI2 / period + sin_offset)

        return quad_height * scale_mult, (1 + scale_mult)
    else
        return 0, 1
    end
end

