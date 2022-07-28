


-- maybe we should make this global
local constants = require("shared.constants")



on("newPlayer", function(username)
    -- create player here.
    local e = entities.player()
    e.x = 0
    e.y = 0
    e.z = 0
    e.controller = username
    e.inventory = {width = 8, height = 8}
end)


on("createWorld", function()
    -- create world here.
    -- For future, we will want the initial spawn platform to be indestructable.
    print("createWorld")
    for x=-5, 5 do
        for y=-5, 5 do
            local xx = x * constants.TILE_SIZE
            local yy = y * constants.TILE_SIZE
            local e = entities.grass_tile()
            e.image = "grass_tile2"            
            e.x = xx
            e.y = yy
        end
    end
end)

