

local function make_player(uname)
    local ent = entities.player()
    ent.x = math.random(-10, 20)
    ent.y = math.random(-10, 20)
    ent.vx, ent.vy = 0,0
    ent.controller = uname
    ent.inventory = {
        width = 6; height = 4;color = {math.random(),math.random(),math.random()}
    }
end


on("join", function(uname)  
    for i=1, 3 do  
        make_player(uname)
    end

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



