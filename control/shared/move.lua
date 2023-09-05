

--[[

syncing for moveX and moveY

]]

local LOOK_SYNC_THRESHOLD = 0.1




sync.autoSyncComponent("moveX", {
    lerp = true,
    numberSyncThreshold = LOOK_SYNC_THRESHOLD,
    syncWhenNil = true,
    
    bidirectional = {
        shouldAcceptServerside = function(ent, moveX)
            -- Only accept packets that
            return type(moveX) == "number" 
        end,

        shouldForceSyncClientside = function(ent, moveX)
            -- always take the client's move position as the correct one
            return false
        end
    }
})


sync.autoSyncComponent("moveY", {
    lerp = true,
    numberSyncThreshold = LOOK_SYNC_THRESHOLD,
    syncWhenNil = true,
    
    bidirectional = {
        shouldAcceptServerside = function(ent, moveY)
            return type(moveY) == "number" 
        end,

        shouldForceSyncClientside = function(ent, moveY)
            -- always take the client's move position as the correct one
            return false
        end
    }
})







local getAgility = require("shared.get_agility")

local max, min, distance = math.max, math.min, math.distance


local moveGroup = umg.group("moveX", "moveY", "x", "y")

--[[

Now, we set entity velocity based on their moveX, moveY values.

]]


local MOVE_THRESHOLD = 0.1
-- The distance that an entity "move" position must be away from an
-- entity before it actually tries to move there.



local function setVelFromMove(ent, dt)
    print("heyhey", ent:type())

    if (not ent.moveX) and (not ent.moveY) then
        -- If we don't have moveX or moveY, return early.
        return
    end

    local x, y = ent.x, ent.y
    local moveX, moveY = ent.moveX or x, ent.moveY or y

    -- ensure that entity actually has velocity components
    ent.vx = ent.vx or 0
    ent.vy = ent.vy or 0

    local agility = getAgility(ent)
    local speed = xy.getSpeed(ent)

    local dvx = (moveX - x)
    local dvy = (moveY - y)
    local mag = distance(dvx, dvy)

    if mag > MOVE_THRESHOLD then
        dvx = dvx / mag
        dvy = dvy / mag
    else
        dvx = 0
        dvy = 0
    end

    dvx = dvx * agility * dt
    dvy = dvy * agility * dt

    --[[
    TODO::: in the future, we should allow for question-buses to
    do custom velocity mappings.
        Perhaps use reducer:  reducers.PRIORITY_VECTOR
    this would allow for potential pathfinding, as opposed to just
    blindly moving towards the target.
    ]]
    ent.vx = min(speed, max(-speed, ent.vx + dvx))
    ent.vy = min(speed, max(-speed, ent.vy + dvy))
end



local function shouldUpdate(ent)
    if client then
        -- On clientside:
        -- Only update if we are controlling this entity
        return sync.isClientControlling(ent)
    else
        -- serverside:
        return not sync.getController(ent)
    end

    -- if server then
    --     -- On serverside:
    --     -- Only update if this entity isn't being controlled by a player.
    --     
    -- end
end


umg.on("@update", function(dt)
    for _, ent in ipairs(moveGroup) do
        if shouldUpdate(ent) then
            setVelFromMove(ent, dt)
        end
    end
end)

