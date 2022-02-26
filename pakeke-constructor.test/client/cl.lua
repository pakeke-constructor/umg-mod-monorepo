


on("join", function(uname)
    local ent = entities.player()
    ent.image = "3d_player_down_1"
    ent.x = 10
    ent.y = 10
    ent.vx, ent.vy = 0,0
    ent.controller = uname
end)


on("preDraw", function()
    graphics.clear(0.5,0.2,0.7)
end)



