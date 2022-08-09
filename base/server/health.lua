


local hpGroup = group("health", "maxHealth")


on("tick", function(dt)
    for _, ent in ipairs(hpGroup)do
        if ent.regen then
            local amount = ent.regen * dt
            ent.health = math.min(ent.maxHealth, ent.health + amount)
            if ent._previousHealth then
                if ent._previousHealth ~= ent.health then
                    server.broadcast("changeEntHealth", ent.health, ent.maxHealth)
                end
            end
            ent._previousHealth = ent.health
        end

        if ent.health <= 0 then
            server.broadcast()
            ent.
            call("dead", ent)
            ent:delete()
        end
    end
end)





