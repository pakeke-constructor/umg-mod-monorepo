

# attack mod.  Handles basic AI for attacking, and splash damage.


NOTE: 
This mod requires A LOT of setup to actually use properly.

On it's own, this mod doesn't actually deal any damage; it's up to YOU
to determine how (and if) damage is dealt.

For a basic setup though, you can use the following code:
```lua

-- Basic setup for attack types:
umg.on("attackMelee", function(ent, targetEnt)
    -- we could prevent the attack if `ent` is stunned, for example
    attack.attack(ent, targetEnt)
end)

umg.on("attackRanged", function(ent, targetEnt)
    local bullet = server.entities.bullet(ent.x, ent.y)
    bullet.moveBehaviourTargetEntity = targetEnt
    -- When bullet collides, bullet should call `attack.attack(ent, target)`
end)

umg.on("attackItem", function(ent, targetEnt)
    items.useHoldItem(ent, targetEnt)
end)




umg.on("attack", function(ent, targetEnt, effectiveness)

end)

