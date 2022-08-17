

local attack = require("server.attack")


local projectileEnts = group("attackBehaviourProjectile")


projectileEnts:onAdded(function(projectile_ent)

end)



local HIT_RANGE = 4



local function move(projectile_ent, dt)

end


on("update", function(dt)
    for _, ent in ipairs(projectileEnts)do
        local abp = ent.attackBehaviourProjectile
        local target_ent = abp.target_ent
        if math.distance(target_ent, ent) < HIT_RANGE then
            -- that's a hit!
            attack(abp.projector_ent, target_ent)
        end
    end
end)



