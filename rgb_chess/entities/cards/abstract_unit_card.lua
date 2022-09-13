
local buy, reroll
if server then
    reroll = require("server.reroll")
    buy = require("server.buy")
end




--[[
    abstract card entity

    entities that extend this will inherit these components:
]]
return {
    "x","y",
    "rgbTeam",
    "rgb",
    "color",
    "cost",

    image = "invisible_card",

    onClick = function(ent, username, button)
        if button == 1 and ent.rgbTeam == username then
            if server then
                if buy.tryBuy(ent) then
                    reroll.rerollSingle(ent.rgbTeam, ent.shopIndex)
                end
            end
        end
    end,

    init = base.entityHelper.initPosition
}


