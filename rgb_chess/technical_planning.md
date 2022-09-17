
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


card = {
    name = "brute x 1", -- card name

    description = [[ 
        hp 5
        dmg 5
        gains +1 hp when an @ ally spawns
    ]], -- card description.
    -- All `@` symbols are replaced with the color of the card.

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

ent.onUpgrade = function(ent) ... end

ent.onBuff = function(ent, buffer_ent) ... end
ent.onDebuff = function(ent, debuffer_ent) ... end

ent.onBuy = function(ent) ... end
ent.onSell = function(ent) ... end

ent.onDamage = function(ent, dmger_ent) ... end
ent.onHeal = function(ent, healer_ent) ... end

ent.onAttack = function(ent, targ, dmg) ... end -- called whenever `ent` attacks.

ent.onStun = function(ent) ... end

ent.onAllySummoned = function(ent, summoned_ent) ... end

ent.onReroll = function(ent) ... end

ent.onStartTurn = function(ent) ... end
ent.onEndTurn = function(ent) ... end

ent.onStartBattle = function(ent) ... end
ent.onEndBattle = function(ent) ... end

```




### Callbacks:
```lua

call("buff", unit, attackAmount, healthAmount, fromUnit=nil, depth=0)
call("debuff", unit, attackAmount, healthAmount, fromUnit=nil, depth=0)

call("attack", attacker_ent, target_ent, dmg) -- from attackBehaviour mod.


 -- self explanatory:
call("startBattle")
call("endBattle")

call("startTurn")
call("endTurn")

```

