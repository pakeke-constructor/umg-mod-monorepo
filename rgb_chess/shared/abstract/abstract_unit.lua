


local select
if client then
    select = require("client.shop.select")
end


--[[
    entities that extend this will inherit these components:
]]
return {
    rgbUnit = true, -- Tells the systems that this entity is a unit

    onClick = function(ent, username, button)
        -- TODO: Move this out into it's own system please
        if client then
            if username == ent.rgbTeam and button == 1 then
                select.select(ent)
            end
        end
    end;

    physics = {
        shape = love.physics.newCircleShape(5);
        friction = 7
    };

    healthBar = {
        offset = 20,
        color = {0.8,0.8,0.8},
        shiny = true
    },

    openable = {
        distance = 200 -- can open from large distance away.
    },

    makeUnitInventory = {
        -- automatically generates an inventory
        width = 3,
        height = 1,
    }
}



