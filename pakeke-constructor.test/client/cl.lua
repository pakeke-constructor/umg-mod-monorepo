


on("join", function(username)
    local ent = entities.player()
    ent.image = "3d_player_up_1"
    ent.x = 10
    ent.y = 10
    ent.vx, ent.vy = 0,0
    ent.controller = username
end)


