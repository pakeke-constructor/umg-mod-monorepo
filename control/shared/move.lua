

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

    local dvx = (moveX - x)
    local dvy = (moveY - y)
    local mag = math.distance(dvx, dvy)

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
    local vx = min(speed, max(-speed, ent.vx + dvx))
    local vy = min(speed, max(-speed, ent.vy + dvy))

    -- this code assumes that the move system uses the same delta time as this system.
    local dx, dy = vx*dt, vy*dt

    local mdelta = distance(dx,dy)
    local actual_delta = distance(x-moveX, y-moveY) 

    if mdelta > actual_delta and actual_delta > 0 then
        -- We don't want the entity to overshoot, so we cap the velocity.
        -- This ensures that the velocity is capped if we are really close to the object.
        -- (Or if there is a really high dt value.)
        -- if the position after velocity addition is further away than move target,
        -- reduce the velocity such that the entity doesn't overshoot.

        -- TODO: This is quite hacky!!! This system should not be
        -- Changing the position of entities like this!!!
        assert(actual_delta > 0, "Wot")
        ent.x = ent.moveX
        ent.y = ent.moveY
        ent.vx = 0
        ent.vy = 0
    else
        ent.vx = vx
        ent.vy = vy
    end
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

