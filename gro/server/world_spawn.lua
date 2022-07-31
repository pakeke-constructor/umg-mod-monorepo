


-- maybe we should make this global
local constants = require("shared.constants")



on("newPlayer", function(username)
    -- create player here.
    local e = entities.player(username)
end)


on("createWorld", function()
    -- create world here.
    -- For future, we will want the initial spawn platform to be indestructable.
    for x=-5, 5 do
        for y=-5, 5 do
            local xx = x * constants.TILE_SIZE
            local yy = y * constants.TILE_SIZE
            entities.grass_tile(xx, yy)
        end
    end

    for i=1, 10 do
        local MIN,MAX = -4 * constants.TILE_SIZE, 4 * constants.TILE_SIZE
        local x = math.random(MIN,MAX)
        local y = math.random(MIN,MAX)
        entities.grass_seed_item(x,y)
    end

    entities.crafting_table(0,0)
end)

