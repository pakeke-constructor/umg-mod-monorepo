
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
    "x", "y",
    "vx", "vy",
    "image",
    "color",
    "category",

    "rgb",
    "rgbTeam", -- the team this entity is in
    "rgb_saveStats", -- a table for saving entity stats before combat.

    "attackDamage", "attackSpeed",
    "health", "maxHealth",
    "speed",

    "cardType",
    "squadron",

    onClick = function(ent, username, button)
        if client then
            if username == ent.rgbTeam and button == 1 then
                select.select(username, ent)
            end
        end
    end;

    physics = {
        shape = physics.newCircleShape(5);
        friction = 7
    };

    attackBehaviour = {
        type = "melee",
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

