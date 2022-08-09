


client.on("changeEntHealth",function(ent, health, maxHealth)
    ent.health = health
    ent.maxHealth = maxHealth
end)



on("drawEntity", function(ent)
    if ent.healthBar and ent.health then
        -- draw the healthbar!
        
        -- TODO. Draw hp bar here.
    end
end)


