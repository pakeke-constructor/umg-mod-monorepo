

local function make_player(uname)
    local ent = entities.player()
    ent.x = math.random(-60, 60)
    ent.y = math.random(-60, 60)
    ent.vx, ent.vy = 0,0
    ent.controller = uname
    ent.inventory = {
        width = 6; height = 4; color = {1,1,1}
    }
end


on("join", function(uname)
    make_player(uname)

    for i=1, 10 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = entities.item()
        e.x = x
        e.y = y
    end

    for i=1, 30 do
        local MAG = 250
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



