

# callbacks:
```lua

startBattle() -- battle starts
endBattle() -- battle ends

startTurn() -- turn starts
endTurn() -- turn ends

attack(atcker_ent, targ_ent, dmg) -- emitted by attackBehaviour mod

reroll(rgbTeam) -- called when a board rerolls

buff(unit, attackAmount, healthAmount, fromUnit, depth) 
debuff(unit, attackAmount, healthAmount, fromUnit, depth)


-- THE FOLLOW CALLBACKS
-- ARE NOT YET IMPLEMENTED:
shield(unit, shieldAmount)
breakShield(unit)

stun(unit)

buy(unit)
sell(unit)

levelUp(unit)
--  ==============




```

