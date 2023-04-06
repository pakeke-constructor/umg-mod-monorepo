

local RANGE = 200

local select
if client then
    select = require("client.select")
end


--[[
    abstract ranged entity

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

    attackBehaviour = {
        type = "ranged",
        range = RANGE,
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

