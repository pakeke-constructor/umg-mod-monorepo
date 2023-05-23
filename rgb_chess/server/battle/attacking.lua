
local shieldAPI = require("server.engine.shields")
local rgbAPI = require("server.engine.rgb_api")

local abilities = require("shared.abilities.abilities")


umg.on("meleeAttack", function(ent, targetEnt)
    if umg.exists(targetEnt) and umg.exists(ent) then
        attack.attack(ent, targetEnt)
    end
end)


umg.on("rangedAttack", function(ent, targetEnt)
    assert(ent.attackDamage,"?")
    if umg.exists(targetEnt) then
        rgbAPI.damage(ent, targetEnt, ent.attackDamage)
    end
end)



umg.on("itemAttack", function(ent, targetEnt)
    if ent.inventory and ent.inventory:getHoldItem() then
        items.useHoldItem(ent, targetEnt)
    end
end)



umg.on("attack", function(attackerEnt, targetEnt, effectiveness)
    -- TODO: Add support for shielding, resistances, etc here.
    local damage = attackerEnt.attackDamage * effectiveness
    damage = shieldAPI.getDamage(targetEnt, damage)
    targetEnt.health = targetEnt.health - damage
    abilities.trigger("allyDamage", targetEnt.rgbTeam)
    abilities.trigger("allyAttack", attackerEnt.rgbTeam)
    umg.call("rgbAttack", attackerEnt, targetEnt, damage)
end)

