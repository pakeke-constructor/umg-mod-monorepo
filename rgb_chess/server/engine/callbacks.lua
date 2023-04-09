

local Board = require("server.board")



umg.on("rgbAttack", function(atcker_ent, targ_ent, dmg)
    if targ_ent.onDamage then
        targ_ent:onDamage(atcker_ent, dmg)
    end
    if atcker_ent.onAttack then
        atcker_ent:onAttack(targ_ent, dmg)
    end
end)




local startBattleEnts = umg.group("onStartBattle")
local endBattleEnts = umg.group("onEndBattle")

umg.on("startBattle", function()
    for _, ent in ipairs(startBattleEnts) do
        ent:onStartBattle()
    end
end)

umg.on("endBattle", function()
    for _, ent in ipairs(endBattleEnts) do
        ent:onEndBattle()
    end
end)





local startTurnEnts = umg.group("onStartTurn")
local endTurnEnts = umg.group("onEndTurn")

umg.on("startTurn", function()
    for _, ent in ipairs(startTurnEnts) do
        ent:onStartTurn()
    end
end)

umg.on("endTurn", function()
    for _, ent in ipairs(endTurnEnts) do
        ent:onEndTurn()
    end
end)




local allySummonEnts = umg.group("onSummon")
local allySoldEnts = umg.group("onAllySold")
local allyDeathEnts = umg.group("onAllyDeath")

umg.on("summonUnit", function(summoned_ent)
    for _, e in ipairs(allySummonEnts) do
        if e.rgbTeam == summoned_ent.rgbTeam and summoned_ent ~= e then
            e:onAllySummoned(summoned_ent)
        end
    end
end)

umg.on("sellUnit", function(sold_ent)
    for _, e in ipairs(allySoldEnts) do
        if e.rgbTeam == sold_ent.rgbTeam and sold_ent ~= e then
            e:onAllySold(sold_ent)
        end
    end
    if sold_ent.onSell then
        sold_ent:onSell()
    end
end)

umg.on("entityDeath", function(dead_ent)
    for _, e in ipairs(allyDeathEnts) do
        if e.rgbTeam == dead_ent.rgbTeam and dead_ent ~= e then
            e:onAllyDeath(dead_ent)
        end
    end 
end)

umg.on("buyUnit", function(ent)
    if ent.onBuy then
        ent:onBuy()
    end
end)



umg.on("reroll", function(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    for _, ent in board:iterUnits() do
        if ent.onReroll then
            ent:onReroll()
        end
    end
end)



local BUFF_TYPES = constants.BUFF_TYPES

umg.on("buff", function(unit, buffType, amount, buffer_ent, depth)
    assert(BUFF_TYPES[buffType], "???")
    if unit.onBuff then
        unit:onBuff(buffType, amount, buffer_ent, depth)
    end
end)

umg.on("debuff", function(unit, buffType, amount, buffer_ent, depth)
    assert(BUFF_TYPES[buffType], "???")

    if unit.onDebuff then
        unit:onDebuff(buffType, amount, buffer_ent, depth)
    end
end)





local shieldBreakGroup = umg.group("onAllyShieldBreak")

umg.on("breakShield", function(ent, shield)
    for _, e in ipairs(shieldBreakGroup) do
        if e.rgbTeam == ent.rgbTeam then
            e:onAllyShieldBreak(ent, shield)
        end
    end
    if ent.onShieldBreak then
        ent:onShieldBreak(shield)
    end
end)

