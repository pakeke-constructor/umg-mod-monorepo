
local buy, reroll
if server then
    reroll = require("server.shop.reroll")
    buy = require("server.shop.buy")
end



--[[
    Unit card entity
]]
return {
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

    init = function(e,x,y,options)
        assert(options.rgbTeam)
        assert(options.cardBuyTarget)

        e.cardBuyTarget = options.cardBuyTarget
        e.rgbTeam = options.rgbTeam
        base.initializers.initXY(e,x,y)
    end
}


