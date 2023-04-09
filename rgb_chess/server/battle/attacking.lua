
local shieldAPI = require("server.engine.shields")



umg.on("meleeAttack", function(ent, targetEnt)
    if umg.exists(targetEnt) and umg.exists(ent) then
        attack.attack(ent, targetEnt)
    end
end)


umg.on("rangedAttack", function(ent, targetEnt)
    assert(ent.attackDamage,"?")
    if umg.exists(targetEnt) then
        local bullet = server.entities.projectile(ent.x, ent.y, {
            projectileType = constants.PROJECTILE_TYPES.DAMAGE,
            attackDamage = ent.attackDamage,
            targetEntity = targetEnt,
            sourceEntity = ent
        })
        bullet.color = ent.color
        -- When bullet collides, this will call rgbProjectileHit.
    end
end)


umg.on("itemAttack", function(ent, targetEnt)
    if ent.holdItem then
        items.useHoldItem(ent, targetEnt)
    end
end)



umg.on("attack", function(attackerEnt, targetEnt, effectiveness)
    -- TODO: Add support for shielding, resistances, etc here.
    local damage = attackerEnt.attackDamage * effectiveness
    damage = shieldAPI.getDamage(targetEnt, damage)
    targetEnt.health = targetEnt.health - damage
    umg.call("rgbAttack", attackerEnt, targetEnt, damage)
end)

