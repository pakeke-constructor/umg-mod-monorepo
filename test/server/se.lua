



local function make_player(uname)
    local ent = entities.player()
    ent.x = math.random(-10, 10)
    ent.y = math.random(-10, 10)
    ent.vx, ent.vy = 0,0
    ent.controller = uname
    ent.inventory = {
        width = 6; height = 4; color = {1,1,1}
    }
    return ent
end



local function make_grass(x,y)
    local grass = entities.grass()
    grass.x = x
    grass.y = y
    local rand = math.random(1, 7)
    grass.image = "grass_" .. tostring(rand)
end


server.on("spawnPlayer", function(username, x, y)
    local e = make_player(username)
    e.x = x
    e.y = y
end)



on("createWorld", function()
    for i=1, 30 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = entities.item()
        e.stackSize = math.floor(math.random(1,5))
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

    for i=1, 100 do
        local MAG = 50
        make_grass(math.random(-MAG, MAG), math.random(-MAG, MAG))
    end
end)




on("playerJoin", function(uname)
    make_player(uname)
end)



