

local triggers = {}

local Trigger = base.Class("rgb-chess:Trigger")


Trigger()



triggers.TYPES = base.enum({
    "allyDeath",
    -- "enemyDeath", NYI

    "allyBuff",
    "allyDebuff",

    "allySummoned",
    "allySold",
 
    "allyDamage",
    "onAllyHeal",
    "onAllyAttack",

    "allyStun",

    "allyShieldBreak", 
    "allyShieldExpire",

    "allyEquip",
    "allyUnequip",
 
    "reroll",
    "startTurn",
    "endTurn",

    "startBattle",
    "startTurn",

    "ability"
})


return triggers
