
on("join", function(uname)    
    local ent = entities.player()
    ent.image = "3d_player_down_1"
    ent.x = 10
    ent.y = 10
    ent.vx, ent.vy = 0,0
    ent.controller = uname

    for i=1, 1000 do
        local MAG = 450
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local grass = entities.grass()
        grass.x = x
        grass.y = y
        if math.random() < 0.5 then
            grass.image = "grass_5"
        else
            grass.image = "grass_6"
        end
    end
end)


