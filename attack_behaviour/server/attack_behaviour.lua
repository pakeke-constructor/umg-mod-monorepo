

local attackGroup = group("attackBehaviour")





local function attackMelee(ent, target)
    
end

local function attackRanged(ent, target)

end

local function attackItem(ent, target)

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
        if ent ~= src_ent then
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
    local last_attack = ent.attackBehaviour_lastAttack or now
    if (now - last_attack) > ent.attackSpeed then
        attackTypes[typ](ent, target)
        ent.attackBehaviour_lastAttack = now + ((now - last_attack) - ent.attackSpeed)
    end
end


on("update", function()
    local now = timer.getTime()
    for _, ent in ipairs(attackGroup) do
        if ent.attackBehaviour then
            local target = ent.attackBehaviour_targetEnt
            if not target then
                target = findClosestEntity(ent, ent.attackBehaviour.target)
            end
            if target and math.dist(target, ent) < ent.attackBehaviour.range then
                tryAttack(ent, target, now)
            end
        end
    end
end)

