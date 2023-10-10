

local entityProperties = require("client.helper.entity_properties")


local DEFAULT_SIZE = 10


local function getEntityDisplaySize(ent)
    --[[
        returns (roughly) the (width, height) of an entity
    ]]
    local scale = entityProperties.getScale(ent)

    local sx = entityProperties.getScaleX(ent) * scale
    local sy = entityProperties.getScaleY(ent) * scale

    local size_x, size_y = DEFAULT_SIZE, DEFAULT_SIZE
    if ent.image then
        size_x, size_y = rendering.getImageSize(ent.image)
    end

    return sx * size_x, sy * size_y
end


return getEntityDisplaySize
