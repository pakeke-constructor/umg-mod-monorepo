

local moveEnts = group("x", "y", "vx", "vy")




local function updateEnt(ent, dt)
    -- We don't move entities if they are being handled by physics system
    if not ent.physics then
        ent.x = ent.x + ent.vx * dt
        ent.y = ent.y + ent.vy * dt
    end
end



on("update", function(dt)
    for _, ent in ipairs(moveEnts) do
        updateEnt(ent, dt)
    end
end)

