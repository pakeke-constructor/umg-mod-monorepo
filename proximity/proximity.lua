


local proximityEntities = group("proximity", "x", "y")


local function selectNew(ent, category, range)
    if not category then
        return
    end
    for _, e in categories.getSet(category):ipairs() do
        if e ~= ent and math.distance(ent, e) <= range then
            return e
        end
    end
end


local function callExit(ent, target)
    if ent.proximity.exit then
        ent.proximity.exit(ent, target)
    end
end

local function callEnter(ent, target)
    if ent.proximity.enter then
        ent.proximity.enter(ent, target)
    end
end


local function updateEnt(ent)
    local prox = ent.proximity
    local range = prox.range
    local category = ent.proximityTargetCategory or prox.targetCategory

    if exists(ent.proximityTargetEntity) then
        -- this vvv is an internal value for use only in this file.
        ent.proximityTarget_entity = ent.proximityTargetEntity
    end

    if ent.proximityTarget_entity and exists(ent.proximityTarget_entity) then
        -- then we already have a target!
        local targ = ent.proximityTarget_entity
        if math.distance(ent, targ) > range or (not exists(targ)) then
            -- oh no! We have to try select a new target.
            local new_target_ent = selectNew(ent, category, range)
            if new_target_ent then
                if exists(targ) then
                    callExit(ent, targ)
                end
                callEnter(ent, new_target_ent)
                ent.proximityTarget_entity = new_target_ent
            else
                callExit(ent, targ)
            end
        end
    else
        local new_target_ent = selectNew(ent, category, range)
        if new_target_ent then
            ent.proximityTarget_entity = new_target_ent
            callEnter(ent, new_target_ent)
        end
    end
end



on("update", function(dt)
    --[[
        TODO:
        This is O(n^2). I don't like this!
    ]]
    for _, ent in ipairs(proximityEntities) do
        updateEnt(ent)
    end
end)

