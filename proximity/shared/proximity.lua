


local proximityGroup = umg.group("proximity", "x", "y")


local function selectNew(ent, category, range)
    if not category then
        return
    end
    for _, e in categories.chunkedIterator(category, ent.x, ent.y) do
        if e ~= ent and math.distance(ent, e) <= range then
            return e
        end
    end
end


local function callExit(ent, target)
    if ent.proximity.exit then
        ent.proximity.exit(ent, target)
    end
    ent.proximity_inRange = false    
    ent.proximity_targetEnt = nil
end

local function callEnter(ent, target)
    if ent.proximity.enter then
        ent.proximity.enter(ent, target)
    end
    ent.proximity_inRange = true
    ent.proximity_targetEnt = target
end


local function doCalls(ent, targ, range)
    if ent.proximity_inRange then
        if math.distance(ent, targ) > range then
            callExit(ent, targ)
        end
    else
        if math.distance(ent, targ) < range then
            callEnter(ent, targ)
        end
    end
end


local function updateEnt(ent)
    local prox = ent.proximity
    assert(type(prox) == "table", "incorrect usage of proximity component.")
    local range = prox.range
    assert(range, "proximity component doesn't have range value!")
    local category = ent.proximityTargetCategory or prox.targetCategory

    -- INTERNAL VALUES, USED BY THIS SYSTEM:
    -- ent.proximity_targetEnt = ent
    -- ent.proximity_inRange = true/false

    -- Special case, when we are looking for only one target ent
    if umg.exists(ent.proximityTargetEntity) then
        ent.proximity_targetEnt = ent.proximityTargetEntity
        local targ = ent.proximity_targetEnt
        doCalls(ent, targ, range)
        return
    end

    if ent.proximity_inRange then
        local targ = ent.proximity_targetEnt
        if (not umg.exists(targ)) or math.distance(ent, targ) > range then
            callExit(ent, targ)
        end
    else
        -- We have to try select a new target.
        local new_target_ent = selectNew(ent, category, range)
        if new_target_ent then
            callEnter(ent, new_target_ent)
        end
    end
end



umg.on("gameUpdate", function(dt)
    --[[
        TODO:
        This is O(n^2). I don't like this!
    ]]
    for _, ent in ipairs(proximityGroup) do
        updateEnt(ent)
    end
end)

