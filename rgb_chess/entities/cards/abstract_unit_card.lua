
local buy
if server then
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
    image = "invisible_card",

    onClick = function(ent, username, button)
        if button == 1 and ent.rgbTeam == username then
            if server then
                buy.tryBuy(ent)
            end
        end
    end,

    init = base.entityHelper.initPosition
}


