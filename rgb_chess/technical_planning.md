
## Technical planning:

How are we going to represent cards?

IDEA: Represent cards and units seperately.


# CARDS:
```lua

-- called when card is bought
card.onBuy = function(card) ... end

-- called for every unit that this card affects. (When bought)
card.onBuyAffectUnit = function(card, unit) ... end


card.rgb = RED | GRN | BLU


card.card = {
    name = "brute x 1", -- card name

    description = [[ 
        hp 5
        dmg 5
        gains +1 hp when a [color] ally spawns
    ]], -- card description.
    -- All [color] occurances are replaced with the color of the card.

    baseCost = X
    
    unit = {
        amount = 4;
        type = "entity_type";
        
        -- the health and damage of the entity type.
        -- (These values are optional.)
        health = 4,
        damage = 4
    },
}

card.buyTarget = "1_unit" | "all_units" | "board" | 
                "1_unit_anycol" | "all_units_anycol"



```


# UNIT COMPONENTS:
```lua

ent.rgb = RED | GRN | BLU

ent.rgbTeam = username
ent.category = ent.rgbTeam

ent.moveBehaviour = {...}

ent.attackBehaviour = {...}


ent.squadron = {ent1, ent2, ...} -- The squadron that this unit belongs to.
-- This is only set if `ent` is a swarm unit.  
-- (Swarm units count as 1 slot.)

ent.cardType = "rgb_chess.card_entity" 
-- reference to the card this unit was spawned from.


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

ent.defaultAttackSpeed = 0.5
ent.attackSpeed = 0.5


-- UNIT CALLBACKS:
ent.onDeath = function(ent) ... end

-- ent.onUpgrade = function(ent) ... end -- NOT USING THIS... MAYBE REMOVE?

ent.onBuff = function(ent, buffType, amount, buffer_ent, depth) ... end
ent.onDebuff = function(ent, buffType, amount, buffer_ent, depth) ... end

ent.onBuy = function(ent) ... end
ent.onSell = function(ent) ... end

ent.onDamage = function(ent, dmger_ent) ... end
ent.onHeal = function(ent, healer_ent) ... end

ent.onAttack = function(ent, targ, dmg) ... end -- called whenever `ent` attacks.

ent.onStun = function(ent) ... end

ent.onAllySummoned = function(ent, summoned_ent) ... end
ent.onAllySold = function(ent, sold_ent) ... end
ent.onAllyDeath = function(ent, dead_ent) ... end

ent.onReroll = function(ent) ... end

ent.onStartTurn = function(ent) ... end
ent.onEndTurn = function(ent) ... end

ent.onStartBattle = function(ent) ... end
ent.onEndBattle = function(ent) ... end

```




### Callbacks:
```lua

BUFF_TYPES = {
    ATTACK_DAMAGE = "ATTACK_DAMAGE",
    ATTACK_SPEED = "ATTACK_SPEED",
    SPEED = "SPEED",
    HEALTH = "HEALTH"
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

