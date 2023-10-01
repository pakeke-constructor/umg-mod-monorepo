
## Technical planning:


For a list of components, see `components.md`


### Callbacks:
```lua

--TODO: Should we do something different??
BUFF_TYPES = {
    ATTACK_DAMAGE = "ATTACK_DAMAGE",
    ATTACK_SPEED = "ATTACK_SPEED",
    SPEED = "SPEED",
    HEALTH = "HEALTH",
    SHIELD = "SHIELD"
}

call("buff", unit, BUFF_TYPE, amount, fromUnit=nil, )
call("debuff", unit, BUFF_TYPE, amount, fromUnit=nil, )


call("rgbAttack", attacker_ent, target_ent, dmg) 

 -- self explanatory:
call("startBattle")
call("endBattle")

call("startTurn")
call("endTurn")


call("sellUnit", ent)
call("sellSquadron", {ent1, ent2, ent3})


call("reroll")
call("rerollCard", cardEnt)

```

