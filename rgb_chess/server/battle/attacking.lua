

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


umg.on("attack", function(ent, targetEnt, effectiveness)
    -- TODO: Add support for shielding, resistances, etc here.
    local damage = ent.attackDamage * effectiveness
    targetEnt.health = targetEnt.health - damage
    umg.call("rgbAttack", damage)
end)

