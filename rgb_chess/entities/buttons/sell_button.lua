
local buy, select
if client then
    select = require("client.shop.select")
    buy = require("client.shop.buy")
end



return umg.extend("abstract_button", {
    normalColor = {1,0.2,0.2},
    hoverColor = {0.5,0.1,0.1},

    onClickClient = function(ent)
        local squadron = select.getSelected()
        if squadron then
            buy.sellSquadron(squadron[1])
        end
    end,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "need to pass in rgbTeam")
        base.initializers.initXY(ent,x,y)
        ent.rgbTeam = rgbTeam
        ent.rerollCost = constants.REROLL_COST
        ent.nametag = {
            value = "SELL SELECTED"
        }
    end
})


