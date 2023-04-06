

local moveRotationGroup = umg.group("vx", "vy", "moveRotation")



local DEFAULT_START_ANGLE = 0 -- radians


umg.on("gameUpdate", function(dt)
    --[[
        moveRotation = {
            startAngle = 0 or nil
        }
    ]]
    for _, ent in ipairs(moveRotationGroup) do
        local moveRot = ent.moveRotation
        local startAngle = DEFAULT_START_ANGLE
        if type(moveRot) == "table" then
            startAngle = moveRot.startAngle or DEFAULT_START_ANGLE
        end

        if math.distance(ent.vy, ent.vy) > 0 then
            ent.rot = startAngle + math.atan2(ent.vy, ent.vx)
        end
    end
end)

