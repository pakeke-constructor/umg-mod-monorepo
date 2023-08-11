
require("xy_questions")


local options = require("shared.options")



local function getSpeed(ent)
    local spd = ent.speed or options.DEFAULT_SPEED

    local speed = spd + (umg.ask("xy:getSpeed", ent) or 0)
    local speed_factor = umg.ask("xy:getSpeedMultiplier", ent) or 1

    return speed * speed_factor
end


return getSpeed

