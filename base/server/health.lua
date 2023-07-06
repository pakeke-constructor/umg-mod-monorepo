


local hpGroup = umg.group("maxHealth")

local kill = require("shared.death")



hpGroup:onAdded(function(ent)
    if not ent.health then
        ent.health = ent.maxHealth
    end
end)



local entToPreviousHealth = {
    -- [ent]  =  previous health value that was synced
    -- for delta compression
}


hpGroup:onRemoved(function(ent)
    entToPreviousHealth[ent] = nil
end)



umg.on("@tick", function(dt)
    for _, ent in ipairs(hpGroup)do
        if ent.regen then
            local amount = ent.regen * dt
            ent.health = math.min(ent.maxHealth, ent.health + amount)
        end

        -- delta compression, syncing health values:
        local previousHealth = entToPreviousHealth[ent]
        if previousHealth ~= ent.health then
            -- TODO: move this file to shared/, and change this to use `proxyEventToClient`
            server.broadcast("changeEntHealth", ent, ent.health, ent.maxHealth)
            entToPreviousHealth[ent] = ent.health
        end

        if ent.health <= 0 then
            kill(ent)
        end
    end
end)


