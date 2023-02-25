

local ents = server.entities


local uname_to_player = {

}

local function make_player(uname)
    local ent = ents.player(0, 0, uname)
    ent.z = 0
    uname_to_player[uname] = ent
    return ent
end




chat.handleCommand("spawn", function(sender, entType)
    if entType and server.entities[entType] then
        local p = base.getPlayer(sender)
        local x,y = 0,0
        if p then
            x,y = p.x, p.y + 30
        end
        server.entities[entType](x,y)
    else
        chat.message("SPAWN FAILED: Unknown entity type " .. tostring(entType))
    end
end)

chat.handleCommand("spin", function(sender)
    server.broadcast("spin")
end)




umg.on("@createWorld", function()
    for i=1, 30 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = ents.item()
        e.stackSize = math.floor(math.random(1,5))
        e.x = x
        e.y = y
    end

    for i=1, 4 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = ents.pickaxe()
        e.stackSize = 1
        e.x = x
        e.y = y
    end

    for i=1, 4 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = ents.musket()
        e.stackSize = 1
        e.x = x
        e.y = y
    end

    for i=1, 1 do
        local MAG = 200
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        local e = ents.player_item()
        e.stackSize = 1
        e.x = x
        e.y = y
    end

    for i=1, 30 do
        local MAG = 250
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        ents.block(x,y)
    end

    for i=1, 160 do
        local MAG = 150
        ents.grass(math.random(-MAG, MAG), math.random(-MAG, MAG))
    end

    ents.crate(0,-100)
    ents.crate_button(100, 100)
    ents.crafting_table(-100, 100)
end)


local e1
server.on("spawn", function(u, e)
    server.entities.everything(e.x,e.y)
end)



local control_ents = umg.group("controllable", "x", "y")
server.on("CONGLOMERATE", function(username, ent)
    for _,e in ipairs(control_ents)do
        if e.controller == username then
            e.x = ent.x
            e.y = ent.y
        end
    end
end)



umg.on("newPlayer", function(uname)
    make_player(uname)
end)

