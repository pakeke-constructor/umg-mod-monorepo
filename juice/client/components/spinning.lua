

local sin = math.sin

local tick = 0

local BIG = 0xffffff

umg.on("state:gameUpdate", function(dt)
    tick = (tick + dt) % BIG
end)

local DEFAULT_SPIN_PERIOD = 1.4;
local DEFAULT_SPIN_MAGNITUDE = 1;

local PI2 = math.pi * 2


umg.answer("rendering:getScaleX", function(ent)
    --[[
        returns the scale_x multiplier for spinning component.
        Default is 1.
    ]]
    if ent.spinning then
        local spinning = ent.spinning
        local period = (spinning.period or DEFAULT_SPIN_PERIOD)
        local offset = (ent.id % 31) / period
        local mag = spinning.magnitude or DEFAULT_SPIN_MAGNITUDE
        return mag * sin(tick * PI2 / period + offset)
    else
        return 1
    end
end)
