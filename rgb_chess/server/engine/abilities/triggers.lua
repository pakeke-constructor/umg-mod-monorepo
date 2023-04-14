
--[[

A list of valid ability triggers.
(For use in `ability_dispatch`)

Each trigger dispatches different arguments, so abilities may respond
differently.

]]
local abilityTriggers = {
    "onAllyDeath",-- (allyEnt)
--    "onEnemyDeath",-- (enemyEnt)    --TODO: This will be a bit harder

    "onAllyBuff",-- (buffType, amount, buffer_ent, depth )
    "onAllyDebuff",-- (buffType, amount, buffer_ent, depth )

    "onAllySummoned",-- (summonedEnt)
    "onAllySold",-- (soldEnt)
 
    "onAllyDamage",-- (allyVictimEnt, attackerEnt, damage)
    "onAllyHeal",-- (allyEnt, healerEnt, amount)
    "onAllyAttack",-- (allyEnt, targetEnt, damage)

    "onAllyStun",-- (stunnedAllyEnt, duration)

    "onAllyShieldBreak", -- (allyEnt)
    "onAllyShieldExpire", -- (allyEnt, shieldSize)

--    "onAllyEquip", -- (allyEnt, itemEnt)
--    "onAllyUnequip", -- (allyEnt, itemEnt)
 
    "onReroll",-- ()
    "onStartTurn",-- ()
    "onEndTurn",-- ()

    "onStartBattle"-- ()
}


local validTriggers = {}

for _, trigger in ipairs(abilityTriggers)do
    assert(not validTriggers[trigger], "duplicate trigger name " .. trigger)
    validTriggers[trigger] = trigger
end


return validTriggers

