
local abstractButton = require("shared.abstract.abstract_button")



return umg.extend(abstractButton, {
    onClickServer = function(ent)
        local cost = ent.rerollCost
        local board = rgb.getBoard(ent.rgbTeam)
        local money = board:getMoney()
        if money >= cost then
            board:setMoney(ent.rgbTeam, money - cost)
            board:rerollAllCards(ent.rgbTeam)
        else
            -- TODO:
            -- send feedback here. (Deny sound or something?)
        end
    end,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "need to pass in rgbTeam")
        base.initializers.initXY(ent,x,y)
        ent.rgbTeam = rgbTeam
        ent.rerollCost = constants.REROLL_COST
        ent.nametag = {
            value = "REROLL (COST " .. tostring(ent.rerollCost) .. ")"
        }
    end
})


