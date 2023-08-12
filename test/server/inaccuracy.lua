

local MOVE_THRESHOLD = 5



umg.answer("projectiles:getProjectileInaccuracy", function(item, projectileEnt, holderEnt)
    local espeed = math.distance(holderEnt.vx, holderEnt.vy)
    if espeed > MOVE_THRESHOLD then
        return 1
    end
    return 0
end)

