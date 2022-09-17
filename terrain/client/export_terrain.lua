
local terrainGroup = group("x","y","terrain")


terrainGroup:onAdded(function(ent)
    assert(ent.terrain, "Entity not given terrain value!")
    ent.terrain:bindEntity(ent)
end)

on("mainDraw", function()
    for _, ent in ipairs(terrainGroup) do
        -- TODO:: do this properly,
        -- making sure draworder is correct.
        -- You may need to use `drawIndex`.
        ent.terrain:draw()
    end
end)




export("terrain", {
    Terrain = require("terrain")
})

