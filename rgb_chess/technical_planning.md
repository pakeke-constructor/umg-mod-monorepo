
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
    description = "hp 5\ndmg 5",

    cost = X
    
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


# UNITS:
```lua

ent.rgb = RED | GRN | BLU

ent.moveBehaviour = {...}

ent.attackBehaviour = {...}



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

