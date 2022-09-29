
local buy, select
if client then
    select = require("client.select")
    buy = require("client.buy")
end



return extend("abstract_button", {
    "nametag",
    "rerollCost",
    
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
        base.entityHelper.initPosition(ent,x,y)
        ent.rgbTeam = rgbTeam
        ent.rerollCost = constants.REROLL_COST
        ent.nametag = {
            value = "SELL SELECTED"
        }
    end
})

