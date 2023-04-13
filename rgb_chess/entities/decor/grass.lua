
local GRASS_IMAGES = {}
for i=1, 8 do
    table.insert(GRASS_IMAGES, "grass_" .. tostring(i))
end


return {
    swaying = {},

    init = function(ent, x, y)
        base.initializers.initXY(ent,x,y)
        ent.image = table.random(GRASS_IMAGES)
    end
}

