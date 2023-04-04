
local MELEE_RANGE = 30

local select
if client then
    select = require("client.select")
end


--[[
    abstract melee entity

    entities that extend this will inherit these components:
]]
return {
    onClick = function(ent, username, button)
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

    attackBehaviour = {
        type = "regular",
        range = MELEE_RANGE
    };

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };

    healthBar = {
        offset = 20,
        color = {1,0,0}
    }
}

