
local buy, reroll
if server then
    buy = require("server.shop.buy")
end



local function assertOptions(options)
    assert(options,"?")
    assert(options.rgbTeam, "needs rgbTeam")
    assert(options.cardBuyTarget, "needs cardBuyTarget")
    assert(options.shopIndex, "needs shopIndex")
end



--[[
    Unit card entity
]]
return {
    rgbCard = true,
    scale = 2,

    onClick = function(ent, username, button)
        if button == 1 and ent.rgbTeam == username then
            if server then
                if buy.canBuy(ent) then
                    buy.buyCard(ent)
                    local board = rgb.getBoard(ent.rgbTeam)
                    board:rerollSlot(ent.shopIndex)
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


