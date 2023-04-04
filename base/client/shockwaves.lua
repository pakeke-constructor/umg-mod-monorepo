

local newShockWave = require("_libs.shockwave")


-- Gotta make sure this is loaded:
local Set = require("shared.set")



-- a Set for all shockwave objects that are being drawn
local shockwaveSet = Set()



umg.on("gameUpdate", function(dt)
    for _,sw in ipairs(shockwaveSet) do
        sw:update(dt)
        if sw.isFinished then
            shockwaveSet:remove(sw)
            sw.colour = nil -- easier on GC
        end
    end
end)




umg.on("drawEffects", function()
    for _,sw in ipairs(shockwaveSet) do
        sw:draw()
    end
end)




local function shockwave(options)
    local sw = newShockWave(options)
    shockwaveSet:add(sw)
end



return shockwave

