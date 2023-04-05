

umg.on("attackMelee", function(ent, targetEnt)
    attack.attack(ent, targetEnt)
end)


umg.on("attackRanged", function(ent, targetEnt)
    local bullet = server.entities.bullet(ent.x, ent.y)
    bullet.moveBehaviourTargetEntity = targetEnt
    bullet.color = ent.color
    bullet.proximityTargetEntity = targetEnt
    bullet.shooterEnt = ent
    -- When bullet collides, bullet calls `attack.attack(ent, target)`
end)


umg.on("attackItem", function(ent, targetEnt)
    if ent.holdItem then
        items.useHoldItem(ent, targetEnt)
    end
end)


umg.on("rgbBulletHit", function(shooterEnt, targetEnt)
    if umg.exists(shooterEnt) then
        attack.attack(shooterEnt, targetEnt)
    end
end)



umg.on("attack", function(ent, targetEnt, effectiveness)
    targetEnt.health = targetEnt.health - ent.attackDamage * effectiveness
end)

