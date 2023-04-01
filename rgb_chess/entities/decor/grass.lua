
local GRASS_IMAGES = {}
for i=1, 8 do
    table.insert(GRASS_IMAGES, "grass_" .. tostring(i))
end


return {
    "image",
    "x", "y",
    swaying = {},

    init = function(ent, x, y)
        base.initializers.initXY(ent,x,y)
        ent.image = table.pick_random(GRASS_IMAGES)
    end
}

