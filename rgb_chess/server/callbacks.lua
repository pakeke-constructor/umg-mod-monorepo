

local Board = require("server.board")



on("attack", function(atcker_ent, targ_ent, dmg)
    if targ_ent.onDamage then
        targ_ent:onDamage(atcker_ent, dmg)
    end
    if atcker_ent.onAttack then
        atcker_ent:onAttack(targ_ent, dmg)
    end
end)




local startBattleEnts = group("onStartBattle")
local endBattleEnts = group("onEndBattle")

on("startBattle", function()
    for _, ent in ipairs(startBattleEnts) do
        ent:onStartBattle()
    end
end)

on("endBattle", function()
    for _, ent in ipairs(endBattleEnts) do
        ent:onEndBattle()
    end
end)





local startTurnEnts = group("onStartTurn")
local endTurnEnts = group("onEndTurn")

on("startTurn", function()
    for _, ent in ipairs(startTurnEnts) do
        ent:onStartTurn()
    end
end)

on("endTurn", function()
    for _, ent in ipairs(endTurnEnts) do
        ent:onEndTurn()
    end
end)




local allySummonEnts = group("onSummon")
local allySoldEnts = group("onAllySold")
local allyDeathEnts = group("onAllyDeath")

on("summonUnit", function(summoned_ent)
    for _, e in ipairs(allySummonEnts) do
        if e.rgbTeam == summoned_ent.rgbTeam and summoned_ent ~= e then
            e:onAllySummoned(summoned_ent)
        end
    end
end)

on("sellUnit", function(sold_ent)
    for _, e in ipairs(allySoldEnts) do
        if e.rgbTeam == sold_ent.rgbTeam and sold_ent ~= e then
            e:onAllySold(sold_ent)
        end
    end
    if sold_ent:onSell() then
        sold_ent:onSell()
    end
end)

on("dead", function(dead_ent)
    for _, e in ipairs(allyDeathEnts) do
        if e.rgbTeam == dead_ent.rgbTeam and dead_ent ~= e then
            e:onAllyDeath(dead_ent)
        end
    end 
end)

on("buyUnit", function(ent)
    if ent.onBuy then
        ent:onBuy()
    end
end)



on("reroll", function(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    for _, ent in board:iterUnits() do
        if ent.onReroll then
            ent:onReroll()
        end
    end
end)



local BUFF_TYPES = constants.BUFF_TYPES

on("buff", function(unit, buffType, amount, buffer_ent, depth)
    assert(constants.BUFF_TYPES[buffType], "???")
    
    if buffType == BUFF_TYPES.HEALTH then
        unit.health = unit.health + amount
        unit.maxHealth = unit.maxHealth + amount
    elseif buffType == BUFF_TYPES.ATTACK_DAMAGE then
        unit.attackDamage = unit.attackDamage + amount
    elseif buffType == BUFF_TYPES.ATTACK_SPEED then
        unit.attackSpeed = unit.attackSpeed + amount
    elseif buffType == BUFF_TYPES.SPEED then
        unit.speed = unit.speed + amount
    end

    if unit.onBuff then
        unit:onBuff(buffType, amount, buffer_ent, depth)
    end
end)

on("debuff", function(unit, buffType, amount, buffer_ent, depth)
    assert(constants.BUFF_TYPES[buffType], "???")
    
    if buffType == BUFF_TYPES.HEALTH then
        unit.health = unit.health - amount
        unit.maxHealth = unit.maxHealth - amount
    elseif buffType == BUFF_TYPES.ATTACK_DAMAGE then
        unit.attackDamage = unit.attackDamage - amount
    elseif buffType == BUFF_TYPES.ATTACK_SPEED then
        unit.attackSpeed = unit.attackSpeed - amount
    elseif buffType == BUFF_TYPES.SPEED then
        unit.speed = unit.speed - amount
    end

    if unit.onDebuff then
        unit:onDebuff(buffType, amount, buffer_ent, depth)
    end
end)



