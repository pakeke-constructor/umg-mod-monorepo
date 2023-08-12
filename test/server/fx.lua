

local MOVE_THRESHOLD = 5



umg.answer("projectiles:getProjectileInaccuracy", function(item, projectileEnt, holderEnt)
    local espeed = math.distance(holderEnt.vx, holderEnt.vy)
    if espeed > MOVE_THRESHOLD then
        return 1
    end
    return 0
end)






--[[
    spawn on death component
]]
local D=10

umg.on("mortality:entityDeath", function(ent)
    if ent.spawnOnDeath then
        for _, t in ipairs(ent.spawnOnDeath) do
            if t.chance > math.random() then
                local ctor = server.entities[t.type]
                local count = t.count
                for _=1, count do
                    local x, y = ent.x + math.random()*D - D/2, ent.y + math.random()*D - D/2
                    ctor(x, y)
                end
            end
        end
    end
end)

