
## Technical planning:



# GENERAL COMPONENTS:
```lua
ent.rgb = RED | GRN | BLU
ent.rgbTeam = username
ent.category = ent.rgbTeam
ent.moveBehaviour = {...}
ent.attackBehaviour = {...}

ent.shields = {
    {startTime = base.getGameTime(), duration = 4, shieldSize = 10}
    ...
}

ent.squadron = {ent1, ent2, ...} -- The squadron that this unit belongs to.
-- This is only set if `ent` is a swarm unit.  
-- (Swarm units count as 1 slot.)

ent.unitCardInfo = {
    cost = 1,
    name = "Monster x 1",
    description = "Gives +1/1 to a random [color] ally",
    -- All [color] occurances are replaced with the color of the card.
    squadronSize = 1,
}

-- UNIT STATS:
-- units should have all of these stats:
-- NOTE: The defaults should be compulsory!!!! 
-- (This way, we can calculate how much "bonus" stats each unit has.)
ent.defaultSpeed = 20
ent.speed = 20

ent.defaultHealth = 100
ent.health, ent.maxHealth

ent.defaultAttackDamage = 10
ent.attackDamage = 10

ent.defaultManaPower = 5
ent.manaPower = 5

ent.defaultAttackSpeed = 0.5
ent.attackSpeed = 0.5

--[[
    FOR ALL VALID ABILITIES,
    SEE abilities.lua
]]
ent.abilities = {
    {
        type = "onAllyDeath",
        filter = function(ent, ...)
            return true or false 
            -- depending on whether this ability should activate
        end,
        apply = function(ent, ...)
            ... -- what actually happens in the ability
        end
    },
    ... -- Entities can have many abilities
}
```





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

call("buff", unit, BUFF_TYPE, amount, fromUnit=nil, depth=0)
call("debuff", unit, BUFF_TYPE, amount, fromUnit=nil, depth=0)


call("attack", attacker_ent, target_ent, dmg) -- from attackBehaviour mod.


 -- self explanatory:
call("startBattle")
call("endBattle")

call("startTurn")
call("endTurn")

call("sellUnit", )

```

