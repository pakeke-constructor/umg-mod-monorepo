
local hpGroup = umg.group("health")



-- todo: this should be emptyGroup.
local maxHpGroup = umg.group("maxHealth")


maxHpGroup:onAdded(function(ent)
    if (server) then
        ent.health = ent.maxHealth
    end
end)


sync.autoSyncComponent("health", {
    lerp = false
})





local kill = require("shared.kill")



hpGroup:onAdded(function(ent)
    if server then
        ent.health = ent.health or 0
    end
end)



if server then
-- only update health values on server-side.

umg.on("@tick", function(dt)
    for _, ent in ipairs(hpGroup)do
        -- kill ent if ded:
        if server and ent.health <= 0 then
            kill(ent)
        end

        -- do regeneration:
        local regen = ent.regeneration or 0
        local amount = regen * dt
        local maxHealth = ent.maxHealth or math.huge
        ent.health = math.min(maxHealth, ent.health + amount)
    end
end)

end
