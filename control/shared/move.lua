

--[[

syncing for moveX and moveY

]]

local LOOK_SYNC_THRESHOLD = 0.1




sync.autoSyncComponent("moveX", {
    lerp = true,
    numberSyncThreshold = LOOK_SYNC_THRESHOLD,
    
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

local max, min = math.max, math.min


local moveGroup = umg.group("moveX", "moveY", "x", "y")

--[[

Now, we set entity velocity based on their moveX, moveY values.

]]


local MOVE_THRESHOLD = 0.1
-- The distance that an entity "move" position must be away from an
-- entity before it actually tries to move there.

local distance = math.distance


local function setVelFromMove(ent, dt)
    if (not ent.moveX or not ent.moveY) then
        -- If we don't have moveX or moveY, return early.
        return
    end

    local x, y = ent.x, ent.y
    local moveX, moveY = ent.moveX, ent.moveY

    local agility = getAgility(ent)
    local speed = xy.getSpeed(ent)

    local dx = (moveX - x)
    local dy = (moveY - y)
    local mdelta = math.distance(dx, dy)

    if mdelta > MOVE_THRESHOLD then
        dx = dx / mdelta
        dy = dy / mdelta
    else
        dx = 0
        dy = 0
    end

    dx = dx * agility * dt
    dy = dy * agility * dt

    local actual_delta = distance(x-moveX, y-moveY) 
    if mdelta > actual_delta then
        -- We don't want the entity to overshoot, so we cap the velocity.
        -- This ensures that the velocity is capped if we are really close to the object.
        -- (Or if there is a really high dt value.)
        -- if the position after velocity addition is further away than move target,
        -- reduce the velocity such that the entity doesn't overshoot.
        assert(actual_delta > 0, "Wot")
        local ratio = distance(x-moveX, y-moveY) / distance(dx,dy)
        -- Multiply our 
        dx = dx * ratio
        dy = dy * ratio
    end
    

    --[[
    TODO::: in the future, we should allow for question-buses to
    do custom velocity mappings.
        Perhaps use reducer:  reducers.PRIORITY_VECTOR
    this would allow for potential pathfinding, as opposed to just
    blindly moving towards the target.
    ]]
    ent.vx = min(speed, max(-speed, ent.vx + dx))
    ent.vy = min(speed, max(-speed, ent.vy + dy))
end



local function shouldUpdate(ent)
    if client then
        -- On clientside:
        -- Only update if we are controlling this entity
        return sync.isClientControlling(ent)
    end

    if server then
        -- On serverside:
        -- Only update if this entity isn't being controlled by a player.
        return not sync.getController(ent)
    end
end


umg.on("@update", function(dt)
    for _, ent in ipairs(moveGroup) do
        if shouldUpdate(ent) then
            setVelFromMove(ent, dt)
        end
    end
end)

