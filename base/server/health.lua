


local hpGroup = umg.group("maxHealth")



hpGroup:onAdded(function(ent)
    if not ent.health then
        ent.health = ent.maxHealth
    end
end)



umg.on("tick", function(dt)
    for _, ent in ipairs(hpGroup)do
        if ent.regen then
            local amount = ent.regen * dt
            ent.health = math.min(ent.maxHealth, ent.health + amount)
        end

        -- delta compression, syncing health values:
        if ent._previousHealth ~= ent.health then
            server.broadcast("changeEntHealth", ent, ent.health, ent.maxHealth)
            ent._previousHealth = ent.health
        end

        if ent.health <= 0 then
            server.broadcast("dead", ent, ent.health)
            umg.call("dead", ent)
            if ent.onDeath then
                ent:onDeath()
            end
            ent:delete()
        end
    end
end)





