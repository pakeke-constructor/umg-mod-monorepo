

local function findClosestEntity(src_ent, category)
    --[[
        finds the closest entity to `src_ent` in category `category`.
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


local DEACTIVATE_FACTOR = 1.15 -- 15% extra to deactivate, seems reasonable

local function deactivateDist(moveBehaviour)
    return moveBehaviour.deactivateDistance or moveBehaviour.activateDistance * DEACTIVATE_FACTOR
end


local function tryPickNewTarget(ent, mb)
    -- then we pick a new target:
    local best_ent, best_dist = findClosestEntity(ent, mb.target)
    if best_dist <= mb.activateDistance then
        ent.moveBehaviourTarget = best_ent
    end
end


local function defaultHeavyUpdate(ent,dt)
    --[[
        selects the closest entity in target category
    ]]
    local mb = ent.moveBehaviour
    local targ = ent.moveBehaviourTarget
    if targ then
        local dist = math.distance(ent,targ)
        if dist > deactivateDist(mb) then
            ent.moveBehaviourTarget = nil
            tryPickNewTarget(ent, mb)
        end
    else
        tryPickNewTarget(ent,mb)
    end
end


local function moveTo(ent, x, y)
    --[[
        TODO::::
        Make it so the ent's velocity isnt instantaneously set.
        It's probably better to have some aspect of "agility" or something.
    ]]
    local dx,dy = x - ent.x, y - ent.y
    local mag = math.distance(dx,dy)
    if mag > 0 then
        ent.vx = (dx / mag) * ent.speed
        ent.vy = (dy / mag) * ent.speed
    else
        ent.vx = 0
        ent.vy = 0
    end
end




return {
    defaultHeavyUpdate = defaultHeavyUpdate;
    tryPickNewTarget = tryPickNewTarget;
    moveTo = moveTo
}

