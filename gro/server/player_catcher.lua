

--[[

catches the player if they fall off the map.

]]

local constants = require("shared.constants")

local playerCatchGroup = group("controllable", "z", "vz")



local function catchPlayer(ent)
    ent.x = 0
    ent.y = 0
    ent.z = 0
    ent.vx = 0
    ent.vy = 0
    ent.vz = 0
end


server.on("i_fell_off", function(sender, ent)
    if ent.controller ~= sender then return end
    catchPlayer(ent)
end)


on("tick", function()
    for _, ent in ipairs(playerCatchGroup)do
        if ent.z < constants.PLAYER_CATCH_THRESHOLD then
            -- catch player, bring em up
            catchPlayer(ent)
        end
    end
end)

