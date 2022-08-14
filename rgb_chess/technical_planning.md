
## Technical planning:

How are we going to represent cards?

IDEA: Represent cards and units seperately.


# CARDS:
```lua

-- called when card is bought
card.onBuy = function(card) ... end

-- called for every unit that this card affects. (When bought)
card.onBuyAffectUnit = function(card, unit) ... end


card.color = RED | GRN | BLU

card.unit = {
    amount = 4;
    type = "entity_type"
}


card.buyTarget = "1_unit" | "all_units" | "board" | 
                "1_unit_anycol" | "all_units_anycol"

card.cost = X


```


# UNITS:
```lua

ent.moveBehaviour = {...}

ent.attackBehaviour = {...}



ent.onDeath = function(ent) ... end

ent.onUpgrade = function(ent) ... end

ent.onBuff = function(ent, buffer_ent) ... end
ent.onDebuff = function(ent, debuffer_ent) ... end

ent.onBuy = function(ent) ... end
ent.onSell = function(ent) ... end

ent.onUpdateSecond = function(ent) ... end -- called once per second.

ent.onDamage = function(ent, dmger_ent) ... end
ent.onHeal = function(ent, healer_ent) ... end

ent.onStun = function(ent) ... end

ent.onSummon = function(ent, summoned_ent) ... end

ent.onReroll = function(ent) ... end

ent.onRoundStart = function(ent) ... end

ent.onRoundEnd = function(ent) ... end

```




### Callbacks:
```lua

call("buff", unit, attackAmount, healthAmount, fromUnit=nil)
call("debuff", unit, attackAmount, healthAmount, fromUnit=nil)






```
