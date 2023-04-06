

umg.on("meleeAttack", function(ent, targetEnt)
    attack.attack(ent, targetEnt)
end)


umg.on("rangedAttack", function(ent, targetEnt)
    assert(ent.attackDamage,"?")
    local bullet = server.entities.projectile(ent.x, ent.y, {
        projectileType = constants.PROJECTILE_TYPES.DAMAGE,
        attackDamage = ent.attackDamage,
        targetEntity = targetEnt,
        sourceEntity = ent
    })
    bullet.color = ent.color
    -- When bullet collides, this will call rgbProjectileHit.
end)


umg.on("itemAttack", function(ent, targetEnt)
    if ent.holdItem then
        items.useHoldItem(ent, targetEnt)
    end
end)


umg.on("attack", function(ent, targetEnt, effectiveness)
    -- TODO: Add support for shielding, resistances, etc here.
    targetEnt.health = targetEnt.health - ent.attackDamage * effectiveness
end)

