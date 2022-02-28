
on("join", function(uname)
    local ent = entities.player()
    ent.image = "3d_player_down_1"
    ent.x = 10
    ent.y = 10
    ent.vx, ent.vy = 0,0
    ent.controller = uname

    for i=1, 10 do
        local MAG = 150
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local block = entities.block()
        block.x = x
        block.y = y
        if math.random() < 0.5 then
            block.image = "slant_block"
        else
            block.image = "slant_block2"
        end
    end
end)

