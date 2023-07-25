

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




--[[

Now, we set entity velocity based on their moveX, moveY values.

TODO::: should we allow for question-buses to map different velocity
values in the future?
this would allow for potential pathfinding.

]]





--[[


Ok::::
Lets do some planning of this.

We want to be able to configure different accelleration rates
for our entities.
So, there are 2 parameters here:
- speed (max speed, obtained via `xy.getSpeed(ent)` )
- and accelleration. (agility?)

agility determines how quickly the entity can change direction,
and determins how much "intertia" the entity has.

So, perhaps we create a question: `getAgility(ent)` that gets
the agility for an entity...?


]]



local getAgility = require("shared.get_agility")


local moveGroup = umg.group("moveX", "moveY", "x", "y")


local function setVelFromMove(ent)
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
    
    --[[
    TODO: we aint using agility here!!!!
    Come up with a nice algorithm to use it.
    ]]
    ent.vx = dx * speed
    ent.vy = dy * speed
end



umg.on("@update", function()
    for _, ent in ipairs(moveGroup) do
        setVelFromMove(ent)
    end
end)

