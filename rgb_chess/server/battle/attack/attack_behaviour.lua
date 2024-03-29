
local attack = require("server.battle.attack.attack")


local attackGroup = umg.group("attackBehaviour", "x", "y")


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
end)



local attackTypes = {}


function attackTypes.melee(ent, targetEnt)
    if umg.exists(targetEnt) and umg.exists(ent) then
        attack.attack(ent, targetEnt)
    end
end


function attackTypes.item(ent, targetEnt)
    error("nyi")
end


function attackTypes.ranged(ent, targetEnt)
    assert(ent.power,"?")
    if umg.exists(targetEnt) then
        rgbAPI.damage(ent, targetEnt, ent.power)
    end
end


local updateTypes = {} 

function updateTypes.melee(ent)
end

function updateTypes.item(ent)
    local target = ent.attackBehaviourTargetEntity
    if umg.exists(target) then
        ent.lookX = target.x
        ent.lookY = target.y
    end
end





attackGroup:onAdded(function(ent)
    if ent.attackBehaviour then
        local typ = ent.attackBehaviour.type
        if (not typ) or not (attackTypes[typ]) then
            error("invalid attack behaviour ".. tostring(typ) .. " type for entity " .. ent:type())
        end
    end
end)




local function pollClosestEntity(src_ent, ent, best_ent, best_dist)
    if ent ~= src_ent and ent.health then
        -- we don't want to attack self, and we don't want to hit an entity without
        -- a health component (that wouldn't make sense.)
        local dist = math.distance(ent, src_ent)
        if dist < best_dist then
            best_dist = dist
            best_ent = ent
        end
    end
    return best_ent, best_dist
end



local function findClosestEntity(src_ent, category)
    --[[
        finds the closest entity to `src_ent` in category `category`.
    ]]
    local best_dist = math.huge
    local best_ent = nil
    local x,y = src_ent.x, src_ent.y
    if category then
        for _, ent in categories.chunkedIterator(category,x,y) do 
            best_ent, best_dist = pollClosestEntity(src_ent, ent, best_ent, best_dist)
        end
    else -- no category, so search all entities
        for _, ent in chunks.iterator(x,y) do
            best_ent, best_dist = pollClosestEntity(src_ent, ent, best_ent, best_dist)
        end
    end
    return best_ent, best_dist
end



local function tryAttack(ent, target, now)
    local typ = ent.attackBehaviour.type
    ent.attackBehaviour_lastAttack = ent.attackBehaviour_lastAttack or now
    local last_attack = ent.attackBehaviour_lastAttack
    if (now - last_attack) > ent.attackSpeed then
        local func = attackTypes[typ]
        func(ent, target)
        ent.attackBehaviour_lastAttack = now + ((now - last_attack) - ent.attackSpeed)
    end
end


local function updateAttack(ent)
    local updateFunc = updateTypes[ent.attackBehaviour.type]
    if updateFunc then
        updateFunc(ent)
    end
end




local function updateEnt(ent, now)
    local targetCategory = ent.attackBehaviourTargetCategory or ent.attackBehaviour.target
    local target = ent.attackBehaviourTargetEntity

    if not targetCategory then
        -- if we don't have a valid target category, return
        return nil
    end

    if (not umg.exists(target)) or (not categories.entityHasCategory(ent, targetCategory)) then
        -- if the entity has been deleted, or if it has changed category, reset state
        ent.attackBehaviourTargetEntity = nil
        target = nil
    end
    if (not target) then
        target = findClosestEntity(ent, targetCategory)
    end
    if umg.exists(target) and math.distance(target, ent) < ent.attackBehaviour.range then
        ent.attackBehaviourTargetEntity = target -- we do a bit of cacheing
        tryAttack(ent, target, now)
    end
    updateAttack(ent)
end



umg.on("@tick", function()
    local now = state.getGameTime()
    for _, ent in ipairs(attackGroup) do
        if ent.attackBehaviour then
            updateEnt(ent, now)
        end
    end
end)

