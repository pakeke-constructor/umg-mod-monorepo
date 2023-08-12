
--[[

Makes entities become a rainbow color.


TODO: use OKLab color space for this,
instead of regular RGB.


]]

local getGameTime = state.getGameTime


local rainbowGroup = umg.group("rainbow") 



-- Triangle function; period of 2 pi, amplitude of 1.
local function triangleFunction(t)
    local A = 1 -- amplitude 1
    local P = math.pi
    return (A/P) * (P - math.abs(t % (2*P) - P) )
end



rainbowGroup:onAdded(function(ent)
    if not ent.color then
        ent.color = {1,1,1}
    end
end)


local DEFAULT_PERIOD = 5

local DEFAULT_BRIGHTNESS = 0.2


umg.on("state:gameUpdate", function(dt)
    for _, ent in ipairs(rainbowGroup) do
        local pi = math.pi
        local period = ent.rainbow.period or DEFAULT_PERIOD
        local brightness = ent.rainbow.brightness or DEFAULT_BRIGHTNESS

        local t = (getGameTime()*period) / (pi*2)

        local r = math.max(0, triangleFunction(t))
        local g = math.max(0, triangleFunction(t + 2*pi/3))
        local b = math.max(0, triangleFunction(t + 4*pi/3))

        ent.color[1] = r + brightness
        ent.color[2] = g + brightness
        ent.color[3] = b + brightness
    end
end)



