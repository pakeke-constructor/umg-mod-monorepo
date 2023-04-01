


local reroll
if server then
    reroll = require("server.reroll")
end


return umg.extend("abstract_button", {
    "nametag",
    "rerollCost",

    onClickServer = function(ent)
        local cost = ent.rerollCost
        local money = rgb.getMoney(ent.rgbTeam)
        if money >= cost then
            rgb.setMoney(ent.rgbTeam, money - cost)
            reroll.reroll(ent.rgbTeam)
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


