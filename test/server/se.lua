

local ents = server.entities


local uname_to_player = {}


local function make_player(uname)
    local ent = ents.player(0, 0, uname)
    ent.z = 0
    ent.moveX = 0
    ent.moveY = 0
    uname_to_player[uname] = ent
    return ent
end




local function newItem(ctor, stackSize)
    local MAG = 400
    local e = ctor()
    e.stackSize = stackSize
    local dvec = {x=math.random(-MAG, MAG), y=math.random(-MAG, MAG)}
    items.drop(e, dvec)
    return e
end



local dim1 = "overworld"
local dim2 = "other"



umg.on("@createWorld", function()
    dimensions.server.createDimension(dim2)
    borders.setBorder(dim2, {
        centerX = 0,
        centerY = 0,
        width = 1000,
        height = 10000
    })

    local e = server.entities.test(0,0)
    e.image = "spot_block"

    for i=1, 30 do
        local e = newItem(ents.item, 1)
        e.dimension = dim2
    end

    for i=1, 4 do
        newItem(ents.flare_gun, 1)
    end

    for i=1, 4 do
        newItem(ents.clone_gun, 1)
    end

    for i=1, 4 do
        newItem(ents.musket, 1)
    end

    for i=1, 4 do
        newItem(ents.ak47, 1)
    end

    --[[
    for i=1,30 do
        local MAG = 100
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        ents.slime3(x,y - 1000)
    end
    ]]

    for i=1, 30 do
        local MAG = 250
        local x, y = math.random(-MAG, MAG), math.random(-MAG, MAG)
        ents.block(x,y)
    end

    for i=1, 1000 do
        local MAG = 800
        ents.grass(math.random(-MAG, MAG), math.random(-MAG, MAG))
    end

    for i=1, 5 do
        local MAG = 1000
        ents.pine(math.random(-MAG, MAG), math.random(-MAG, MAG))
    end

    ents.crate(0,-100)
    ents.crate_button(100, 100)
    ents.crafting_table(-100, 100)

end)


local sf = sync.filters


local controlGroup = umg.group("controllable", "x", "y")


server.on("swapdimension", {
    arguments = {sf.string},
    handler = function(username, dim)
        for _,e in ipairs(controlGroup)do
            if e.controller == username then
                e.dimension = dim
            end
        end
    end
})



if server.isWorldPersistent() then
    -- use playersaves API
    umg.on("createPlayer", function(uname)
        make_player(uname)
    end)
else
    -- just spawn a temp player
    umg.on("@playerJoin", function(uname)
        make_player(uname)
    end)
end


