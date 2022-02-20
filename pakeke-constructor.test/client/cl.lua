


on("join", function(username)
    local ent = entities.player()
    ent.x = 10
    ent.y = 10
    ent.vx, ent.vy = 0,0
    ent.controller = username
end)


