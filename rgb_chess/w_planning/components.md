## Components



### Unit entities:
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


--[[
Entities with a `cardInfo` components are
automatically added to the card pool.

For example, unit entities that contain a `cardInfo` component are
automatically added to the card pool.
]]
ent.cardInfo = {
    type = cardTypes.UNIT,
    cost = 5,
    name = "Monster x 1",
    description = "On buy: Gives +1/1 to a random [color] ally",

    -- OPTIONAL VALUES:
    rarity = 1, -- number from 0-1 representing chance of this card 
    -- appearing when compared to other cards. Default = 1.
    minimumTurn = 1, -- minimum turn for this card to appear.
    image = "joker_card" -- custom card image (defaults to blank_card)
    

    -- only needed for cardType UNIT
    unitInfo = {
        symbol = "my_symbol1", -- an image
        squadronSize = 1 -- how many units to spawn
    }

    -- only needed for cardType SPELL
    spellInfo = {
    }
}

```
















# Spell entities:
```lua

ent.cardOnBuy = function(rgbTeam)

end

ent.cardInfo = {...} -- same as before.

```

