

local attack = require("server.attack")


local projectileEnts = group("attackBehaviourProjectile")




local HIT_RANGE = 4

local DEFAULT_SPEED = 300


local function move(ent, x, y, dt)
    local dx = x - ent.x
    local dy = y - ent.y
    local mag = math.distance(dx,dy)
    local speed = ent.speed or DEFAULT_SPEED

    if mag > (speed * dt) then
        dx = (speed * dt * dx) / mag
        dy = (speed * dt * dy) / mag
        ent.x = ent.x + dx
        ent.y = ent.y + dy
    else
        ent.x = x
        ent.y = y
    end
end


on("update", function(dt)
    for _, ent in ipairs(projectileEnts)do
        local abp = ent.attackBehaviourProjectile
        if abp then
            local target_ent = abp.target_ent
            if exists(target_ent) then
                if math.distance(target_ent, ent) < HIT_RANGE then
                    -- that's a hit!
                    attack(abp.projector_ent, target_ent)
                    ent:delete()
                else
                    move(ent, target_ent.x, target_ent.y, dt)
                end
            else
                abp.target_ent = nil
                abp.target_x = target_ent.x
                abp.target_y = target_ent.y
                if math.distance(abp.target_x-ent.x, abp.target_y-ent.x) < HIT_RANGE then
                    ent:delete()
                else
                    move(ent, abp.target_x, abp.target_y, dt)
                end                
            end
        end
    end
end)



