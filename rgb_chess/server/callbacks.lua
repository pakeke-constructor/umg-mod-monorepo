

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




local rerollEnts = group("onReroll")
on("reroll", function()
    for _, ent in ipairs(rerollEnts) do
        ent:onReroll()
    end
end)



on("buff", function(unit, attackAmount, healthAmount, fromUnit, depth)
    if unit.onBuff then
        unit:onBuff(attackAmount, healthAmount, fromUnit, depth)
    end
end)

on("debuff", function(unit, attackAmount, healthAmount, fromUnit, depth)
    if unit.onDebuff then
        unit:onDebuff(attackAmount, healthAmount, fromUnit, depth)
    end
end)






