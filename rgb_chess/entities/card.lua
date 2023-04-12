
local buy, reroll
if server then
    reroll = require("server.shop.reroll")
    buy = require("server.shop.buy")
end



local function assertOptions(options)
    assert(options,"?")
    assert(options.rgbTeam, "needs rgbTeam")
    assert(options.cardEntityType, "needs cardEntityType")
    assert(options.shopIndex, "needs shopIndex")
end



--[[
    Unit card entity
]]
return {
    card = true,

    onClick = function(ent, username, button)
        if button == 1 and ent.rgbTeam == username then
            if server then
                if buy.canBuy(ent) then
                    buy.buyCard(ent)
                    reroll.rerollCardSlot(ent.rgbTeam, ent.shopIndex)
                end
            elseif client then
                -- idk, play sound here or something?
            end
        end
    end,

    init = function(e,x,y,options)
        assertOptions(options)
        for k,v in pairs(options)do
            e[k] = v
        end

        base.initializers.initXY(e,x,y)
    end
}


