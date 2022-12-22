
local Board
if server then
    Board = require("server.board")
end

local GOLD_AMOUNT = 3

return umg.extend("abstract_melee", {
    --[[
        turn start:
        if there are at least 2 [color] allies,
        gain +3 gold
    ]]
    unitCardInfo = {
        name = "Slime x 1",
        description = "Turn start:\nIf theres 2 or more [color] allies, gain +3 gold",
        cost = 1,
    };

    defaultSpeed = 25,
    defaultHealth = 15,
    defaultAttackDamage = 1,
    defaultAttackSpeed = 0.4,

    animation = {"blob0", "blob1", "blob2", "blob3", "blob2", "blob1", speed=0.6};
    
    bobbing = {},

    onStartTurn = function(ent)
        local ct = 0
        for _,e in rgb.iterUnits(ent.rgbTeam) do
            if rgb.areMatchingColors(e,ent) then
                ct = ct + 1
            end
        end
        if ct > 2 then -- accounting for self.
            local b = Board.getBoard(ent.rgbTeam)
            b:setMoney(b:getMoney() + GOLD_AMOUNT)
        end
    end;

    init = base.entityHelper.initPosition    
})


