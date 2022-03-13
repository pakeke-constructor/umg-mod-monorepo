
on("join", function(uname)    
    local ent = entities.player()
    ent.x = 10
    ent.y = 10
    ent.vx, ent.vy = 0,0
    ent.controller = uname
    ent.inventory = {
        width = 10; height = 3;color = {0.5,0.1,0.1}
    }

    for i=1, 20 do
        local MAG = 150
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local block = entities.block()
        block.x = x
        block.y = y
        block.vx = 0
        block.vy = 0
        if math.random() < 0.5 then
            block.image = "slant_block"
        else
            block.image = "slant_block2"
        end
    end
end)



