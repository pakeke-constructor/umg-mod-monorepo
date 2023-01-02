

# callbacks:
```lua

startBattle() -- battle starts
endBattle() -- battle ends

startTurn() -- turn starts
endTurn() -- turn ends

attack(atcker_ent, targ_ent, dmg) -- emitted by attackBehaviour mod

reroll(rgbTeam) -- called when a board rerolls

buff(unit, attackAmount, healthAmount, fromUnit, depth) -- buffing / debuffing
debuff(unit, attackAmount, healthAmount, fromUnit, depth)


```
