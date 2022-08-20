
local attack = require("server.attack")


local attackGroup = group("attackBehaviour")


local ATTACK_TYPES = {
    melee = true, ranged = true, item = true
}
local FALLOFF_TYPES = {
    linear = true, quadratic = true, none = true
}


attackGroup:onAdded(function(ent)
    --[[
        this function is just error checking,
        ensuring that the attackBehaviour component is formatted correctly.
    ]]
    local ab = ent.attackBehaviour
    if not ab.target then
        error("attackBehaviour must have a `target` category value. Not the case for: " .. ent:type())
    end
    if (not ab.type) or (not ATTACK_TYPES[ab.type]) then
        error("invalid attack type for " .. ent:type() .. ": " .. tostring(ab.type))
    end
    if (not ab.range) then
        error("attackBehaviour must have a range, not the case for: " .. ent:type())
    end
    
    if ab.splash then
        local splash = ab.splash
        if type(splash.radius)~="number" then
            error("attackBehaviour.splash table must have a radius value, not the case for: " .. ent:type())
        end
        if splash.damageFalloff and (not FALLOFF_TYPES[splash.damageFalloff]) then
            error("invalid damage falloff value for ent: " .. ent:type())
        end
    end

    if ab.type == "ranged" then
        assert(ab.projectile and entities[ab.projectile], "invalid attackBehaviour.projectile value: " .. tostring(ab.projectile) .. " for ent: " .. ent:type())
    end
end)





local function attackMelee(ent, target_ent)
    print("attack!")
    attack(ent, target_ent)
end


local function attackRanged(ent, target_ent)
    --[[
        for ranged attacking.
        This function spawns a projectile entity.
    ]]
    local etype = ent.attackBehaviour.projectile
    assert(etype and entities[etype], "ranged attacker doesn't have a valid projectile")
    local projectile_ent = entities[etype](ent.x, ent.y)
    assert(projectile_ent:hasComponent("attackBehaviourProjectile"), "This entity is not a projectile! (projectiles require attackBehaviourProjectile component.)")
    projectile_ent.attackBehaviourProjectile = {
        target_ent = target_ent;
        target_x = target_ent.x;
        target_y = target_ent.y;
        projector_ent = ent
    }
end



local function attackItem(ent, target_ent)
    error("not yet implemented.")
    -- TODO.
    
    -- will need a refactor of the items mod;
    -- specifically, we need to add a `holding` component, and get rid of
    -- the inventory:getHoldingItem() nonsense.
end



local attackTypes = {
    melee = attackMelee;
    ranged = attackRanged;
    item = attackItem
}




attackGroup:onAdded(function(ent)
    assert(ent:hasComponent("attackSpeed"), "attackBehaviour entities require an attackSpeed component!")
    assert(ent:hasComponent("attackDamage"), "attackBehaviour entities require an attackDamage component!")
    if ent.attackBehaviour then
        local typ = ent.attackBehaviour.type
        if (not typ) or not (attackTypes[typ]) then
            error("invalid attack behaviour ".. tostring(typ) .. " type for entity " .. ent:type())
        end
    end
end)



local function findClosestEntity(src_ent, category)
    --[[
        finds the closest entity to `src_ent` in category `category`.

        TODO: Do spatial partitioning for this.
    ]]
    local best_dist = math.huge
    local best_ent = nil
    for _, ent in categories.getSet(category):iter() do
        if ent ~= src_ent and ent:hasComponent("health") then
            -- we don't want to attack self, and we don't want to hit an entity without
            -- a health component (that wouldn't make sense.)
            local dist = math.distance(ent, src_ent)
            if dist < best_dist then
                best_dist = dist
                best_ent = ent
            end
        end
    end
    return best_ent, best_dist
end



local function tryAttack(ent, target, now)
    local typ = ent.attackBehaviour.type
    ent.attackBehaviour_lastAttack = ent.attackBehaviour_lastAttack or now
    local last_attack = ent.attackBehaviour_lastAttack
    if (now - last_attack) > ent.attackSpeed then
        attackTypes[typ](ent, target)
        ent.attackBehaviour_lastAttack = now + ((now - last_attack) - ent.attackSpeed)
    end
end


on("update5", function()
    local now = timer.getTime()
    for _, ent in ipairs(attackGroup) do
        if ent.attackBehaviour then
            local target = ent.attackBehaviour_targetEnt
            local targetCategory = ent.attackBehaviour.target
            if not target then
                target = findClosestEntity(ent, targetCategory)
            end
            if target and math.distance(target, ent) < ent.attackBehaviour.range then
                tryAttack(ent, target, now)
            end
        end
    end
end)

