

--[[


Helper module for
`auto_sync_component` and `auto_sync_controllable`


]]

local helper = {}


local abs = math.abs
local type = type
local max, min = math.max, math.min



local EMPTY = {}



local compsBeingSynced = {
    --[[
        [compName] -> true/false
        whether this component is being auto synced or not.
    ]]
}




-- This is hacky! Oh well!!!! 
local EVENT_PREFIX = "_sync_"




local function makeSyncName(compName)
    return EVENT_PREFIX .. compName
end



function helper.registerNewComponent(compName)
    assert(not compsBeingSynced[compName], "This component is already being synced!")
    compsBeingSynced[compName] = true
end



function helper.getRequiredComponents(compName, options)
    local requiredComponents = {compName}
    local extraComps = options.requiredComponents or EMPTY
    for _, comp in ipairs(extraComps)do
        table.insert(requiredComponents, comp)
    end
    return requiredComponents
end
















--[[
    Clientside lerping.

    The way this works, is we receive a number value for a component
    from the server, and we automatically LERP to the new value
    slowly over the next frame.
    This makes things more delayed on the client, but it also
    makes stuff a lot smoother.
]]

local compNameToLerpBuffer = {--[[
    [compName] -> lerpBuffer

    where lerpBuffer = {
        [ent1] -> compVal
        [ent2] -> compVal
    }
]]}


function helper.setLerpValue(ent, compName, compVal)
    local lerpBuf = compNameToLerpBuffer[compName]
    if lerpBuf[ent] then
        -- If there's a lerp value that we are currently lerping,
        -- set the entity comp value to that value.
        -- (i.e.  "jump" to the old value directly)
        ent[compName] = lerpBuf[ent]
    else
        -- Else there's no old value, so just jump directly to the sent value.
        -- (This should only happen when an entity is first created.)
        ent[compName] = compVal
    end

    lerpBuf[ent] = compVal
end




local lastTickDelta = 0.1 -- this value is pretty arbitrary and does matter
local timeOfLastTick = love.timer.getTime()

local MIN_TICK_DELTA = 0.01

umg.on("@tick", function()
    local time = love.timer.getTime()
    lastTickDelta = max(MIN_TICK_DELTA, time - timeOfLastTick)
    timeOfLastTick = time
end)




local function updateEntityWithLerp(ent, compName, targetVal, time)
    local currVal = ent[compName]

    local t = min(1, max(0, (time - timeOfLastTick) / lastTickDelta))
    local delta = (targetVal - currVal) * (1-t)

    ent[compName] = targetVal - delta
end





local function setupClientNumberLerp(compName, options)
    assert(client, "Should only be called on client side!")
    local requiredComponents = getRequiredComponents(compName, options)
    local group = umg.group(unpack(requiredComponents))

    local lerpBuffer = {}
    compNameToLerpBuffer[compName] = lerpBuffer

    group:onRemoved(function(ent)
        -- ensure to clear lerp buffer when entities are removed
        lerpBuffer[ent] = nil
    end)

    umg.on("@update", function(dt)
        local time = love.timer.getTime()
        for _, ent in ipairs(group) do
            if lerpBuffer and lerpBuffer[ent] then
                local targetVal = lerpBuffer[ent]
                updateEntityWithLerp(ent, compName, targetVal, time)
            end
        end
    end)
end
















return helper

