


local uname_to_player = {

}

local function make_player(uname)
    local ent = entities.player(0, 0, uname)
    ent.z = 0
    uname_to_player[uname] = ent
    return ent
end




on("createWorld", function()
    for i=1, 30 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = entities.item()
        e.stackSize = math.floor(math.random(1,5))
        e.x = x
        e.y = y
    end

    for i=1, 4 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = entities.pickaxe()
        e.stackSize = 1
        e.x = x
        e.y = y
    end

    for i=1, 4 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = entities.musket()
        e.stackSize = 1
        e.x = x
        e.y = y
    end

    for i=1, 30 do
        local MAG = 250
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        entities.block(x,y)
    end

    for i=1, 160 do
        local MAG = 150
        entities.grass(math.random(-MAG, MAG), math.random(-MAG, MAG))
    end

    entities.crate()
    entities.crate_button(100, 100)
    entities.crafting_table(-100, 100)
end)


local e1
server.on("spawn", function(u, e)
    if e1 then e1:delete() end
    e1 = entities.enemy(e.x,e.y + 20)
end)



local control_ents = group("controllable", "x", "y")
server.on("CONGLOMERATE", function(username, ent)
    for _,e in ipairs(control_ents)do
        if e.controller == username then
            e.x = ent.x
            e.y = ent.y
        end
    end
end)


on("newPlayer", function(uname)
    make_player(uname)
end)

