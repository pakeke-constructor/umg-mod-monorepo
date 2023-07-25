

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

local function setVelFromMove(ent, dt)
    local agility = getAgility(ent)
    local speed = xy.getSpeed(ent)

    local dx = (ent.moveX - ent.x)
    local dy = (ent.moveY - ent.y)
    local mag = math.distance(dx, dy)

    if mag > 0 then
        dx = dx / mag
        dy = dy / mag
    else
        dx = 0
        dy = 0
    end
    
    dx = dx * agility * dt
    dy = dy * agility * dt

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



umg.on("@update", function(dt)
    for _, ent in ipairs(moveGroup) do
        setVelFromMove(ent, dt)
    end
end)

