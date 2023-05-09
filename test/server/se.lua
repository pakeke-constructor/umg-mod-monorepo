

local ents = server.entities


local uname_to_player = {}


local function make_player(uname)
    local ent = ents.player(0, 0, uname)
    ent.z = 0
    uname_to_player[uname] = ent
    return ent
end



local valid_letters = {
    u=true, m=true, g=true
}

chat.handleCommand("spawnLetter", {
    arguments = {{name = "letter", type = "string"}},
    adminLevel = 0,
    handler = function(sender, letter)
        local p = base.getPlayer(sender)
        if p and valid_letters[letter] then
            local img = "letter_" .. letter
            server.entities.letter(p.x + 16, p.y + 16, img)
        end
    end
})


local function newItem(ctor, stackSize)
    local MAG = 200
    local e = ctor()
    e.stackSize = stackSize
    items.drop(e, math.random(-MAG, MAG), math.random(-MAG, MAG))
end


umg.on("@createWorld", function()
    for i=1, 30 do
        newItem(ents.item, 1)
    end

    for i=1, 4 do
        newItem(ents.pickaxe, 1)
    end

    for i=1, 4 do
        newItem(ents.musket, 1)
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


local sf = sync.filters

local e1
server.on("spawn", {
    arguments = {sf.number, sf.number},
    handler = function(u, x,y)
        server.entities.opacity_test(x,y)
    end
})


local controlGroup = umg.group("controllable", "x", "y")

server.on("CONGLOMERATE", {
    arguments = {sf.table},
    handler = function(username, ent)
        for _,e in ipairs(controlGroup)do
            if e.controller == username then
                e.x = ent.x
                e.y = ent.y
            end
        end
    end
})



umg.on("newPlayer", function(uname)
    make_player(uname)
end)


