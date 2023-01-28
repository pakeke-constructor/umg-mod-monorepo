

local newShockWave = require("_libs.shockwave")


-- Gotta make sure this is loaded:
local Set = require("shared.set")
local typecheck = require("shared.typecheck")



-- a Set for all shockwave objects that are being drawn
local shockwaveSet = Set()



umg.on("gameUpdate", function(dt)
    for _,sw in shockwaveSet:iter()do
        sw:update(dt)
        if sw.isFinished then
            shockwaveSet:remove(sw)
            sw.colour = nil -- easier on GC
        end
    end
end)




umg.on("postDraw", function()
    for _,sw in shockwaveSet:iter() do
        sw:draw()
    end
end)



local tc = typecheck.assert("number", "number", "number", "number", "number", "number", "table?")

local function shockwave(x, y, start_size, end_size, thickness, time, colour)
    tc(x, y, start_size, end_size, thickness, time, colour)
    local sw = newShockWave(x,y,start_size, end_size, thickness, time, colour or {1,1,1,1})
    shockwaveSet:add(sw)
end



return shockwave

