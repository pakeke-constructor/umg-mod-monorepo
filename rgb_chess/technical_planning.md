
## Technical planning:




# CARDS:
There are two types of cards: "Unit cards" and "Other cards".
Unit cards spawn units,
Other cards are spells, items, or upgrades.
```lua

-- FOR UNITS:
card_ent.cardBuyTarget = entities.brute
card_ent.cardType = "unit"
-- FOR SPELLS / ITEMS / OTHER:
card_ent.cardType = "other"
card_ent.cardBuyTarget = entities.spell_1

card_ent.cost = X

card_ent.rgb = RED
card_ent.color = {1,0.3,0.3}

```












# SPELLS / ITEMS / OTHER:
```lua
-- called when card is bought
ent.onBuy = function(card) ... end

-- called for every unit that this card affects. (When bought)
ent.onBuyAffectUnit = function(card, unit) ... end

ent.rgb = RED | GRN | BLU

ent.otherCardInfo = {
    cost = 4,
    name = "Strength spell", -- card name

    description = [[
         [color] ally spawns
    ]], -- card description.
}

ent.buyTarget = "1_unit" | "all_units" | "board" | 
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

ent.unitCardInfo = {
    cost = 1,
    name = "Monster x 1",
    description = "Gives +1/1 to a random [color] ally",
    -- All [color] occurances are replaced with the color of the card.
    squadronSize = 1, }

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

