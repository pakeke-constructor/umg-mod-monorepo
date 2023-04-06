

umg.on("attackMelee", function(ent, targetEnt)
    attack.attack(ent, targetEnt)
end)


umg.on("attackRanged", function(ent, targetEnt)
    local bullet = server.entities.projectile(ent.x, ent.y, {
        projectileSource = ent,
        targetEntity = targetEnt
    })
    bullet.color = ent.color
    -- When bullet collides, this will call rgbProjectileHit.
end)


umg.on("attackItem", function(ent, targetEnt)
    if ent.holdItem then
        items.useHoldItem(ent, targetEnt)
    end
end)


umg.on("attack", function(ent, targetEnt, effectiveness)
    -- TODO: Add support for shielding, resistances, etc here.
    targetEnt.health = targetEnt.health - ent.attackDamage * effectiveness
end)

