
local constants = require("shared.constants")

umg.on("@tick", function()
    local player = base.getPlayer()
    if player then
        if player.z < constants.PLAYER_CATCH_THRESHOLD then
            client.send("i_fell_off") -- help!
            -- The reason we need to double check it here is in the event of a desync
            -- between client and server.
        end
    end
end)

