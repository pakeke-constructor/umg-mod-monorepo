
local abstractButton = require("shared.abstract.abstract_button")



return umg.extend(abstractButton, {
    onClickServer = function(ent)
        local cost = ent.rerollCost
        local board = rgb.getBoard(ent.rgbTeam)
        local money = board:getMoney()
        if money >= cost then
            board:setMoney(money - cost)
            board:reroll()
        else
            -- TODO:
            -- send feedback here. (Deny sound or something?)
        end
    end,


    initXY = true,

    init = function(ent, x, y, rgbTeam)
        assert(rgbTeam, "need to pass in rgbTeam")
        ent.rgbTeam = rgbTeam
        ent.rerollCost = constants.REROLL_COST
        ent.nametag = {
            value = "REROLL (COST " .. tostring(ent.rerollCost) .. ")"
        }
    end
})


