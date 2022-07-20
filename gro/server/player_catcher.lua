

--[[

catches the player if they fall off the map.

]]

local constants = require("shared.constants")

local playerCatchGroup = group("controllable", "z", "vz")



on("tick", function()
    for _, ent in ipairs(playerCatchGroup)do
        if ent.z < constants.PLAYER_CATCH_THRESHOLD then
            -- catch player, bring em up
            ent.x = 0
            ent.y = 0
            ent.z = 0
        end
    end
end)

