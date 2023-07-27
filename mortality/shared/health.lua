
local hpGroup = umg.group("health")



-- todo: this should be emptyGroup.
local maxHpGroup = umg.group("maxHealth")


maxHpGroup:onAdded(function(ent)
    if (server) then
        ent.health = ent.maxHealth
    end
end)




local kill = require("shared.death")



hpGroup:onAdded(function(ent)
    if server then
        ent.health = ent.health or 0
    end
end)


local getRegeneration = require("shared.get_regen")



if server then
-- only update health values on server-side.

umg.on("@tick", function(dt)
    for _, ent in ipairs(hpGroup)do
        -- kill ent if ded:
        if server and ent.health <= 0 then
            kill(ent)
        end

        -- do regeneration:
        local regen = getRegeneration(ent)
        local amount = regen * dt
        local maxHealth = ent.maxHealth or math.huge
        ent.health = math.min(maxHealth, ent.health + amount)
    end
end)

end
