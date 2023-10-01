

--[[
    rotates entities in their direction of motion.

    Great for bullets and stuff.
]]

local rotateOnMovementGroup = umg.group("vx", "vy", "rotateOnMovement")



local DEFAULT_START_ANGLE = 0 -- radians


umg.on("state:gameUpdate", function(dt)
    --[[
        rotateOnMovement = {
            startAngle = 0 or nil
        }
    ]]
    for _, ent in ipairs(rotateOnMovementGroup) do
        local moveRot = ent.rotateOnMovement
        local startAngle = DEFAULT_START_ANGLE
        if type(moveRot) == "table" then
            startAngle = moveRot.startAngle or DEFAULT_START_ANGLE
        end

        if math.distance(ent.vy, ent.vy) > 0 then
            ent.rot = startAngle + math.atan2(ent.vy, ent.vx)
        end
    end
end)

