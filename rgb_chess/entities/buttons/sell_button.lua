
local abstractButton = require("shared.abstract.abstract_button")


local buy, select
if client then
    select = require("client.shop.select")
    buy = require("client.shop.buy")
end



return umg.extend(abstractButton, {
    normalColor = {1,0.2,0.2},
    hoverColor = {0.5,0.1,0.1},

    onClickClient = function(ent)
        local squadron = select.getSelected()
        if squadron then
            buy.sellSquadron(squadron[1])
        end
    end,

    initXY = true,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "need to pass in rgbTeam")
        ent.rgbTeam = rgbTeam
        ent.rerollCost = constants.REROLL_COST
        ent.nametag = {
            value = "SELL SELECTED"
        }
    end
})


