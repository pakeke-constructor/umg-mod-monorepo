

local triggers = {}


local triggerTypeToDescription = {
    allyDeath = "When an ally dies:",
    -- "enemyDeath", NYI

    allyBuff = "When an ally is buffed:",
    allyDebuff = "When an ally is debuffed:",

    allySummoned = "When an ally is summoned:",
    allySold = "When an ally is sold:",
 
    allyDamage = "When an ally takes damage:",
    onAllyHeal = "When an ally is healed:",
    onAllyAttack = "When an ally attacks:",

    allyStun = "When an ally is stunned:",

    allyShieldBreak = "When an ally's shield breaks:", 
    allyShieldExpire = "When an ally's shield expires:",

    allyEquip = "When an ally equips an item:",
    allyUnequip = "When an ally unequips an item:",
 
    reroll = "On reroll:",
    startTurn = "On turn start:",
    endTurn = "On turn end:",

    startBattle = "On battle start:",
    endBattle = "On battle end:",

    ability = "When an ability is procs:"
}


return triggers
