
--[[

Automatic component syncing facilities.

usage:
sync.autoSyncComponent(<compName>, options)


See auto_sync_component.md for example!

]]

local constants = require("constants")


local filters = require("shared.filters")
local control = require("shared.control")
local tickDelta = require("shared.tick_delta")


local isControlledBy = control.isControlledBy


local VALID_OPTIONS = {
    syncWhenNil = true,
    lerp = true,
    noDeltaCompression = true,
    numberSyncThreshold = true,
    requiredComponents = true,
    bidirectional = true
}



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




local function isDifferent(compVal, lastVal, options)
    if type(compVal) == "number" and type(lastVal) == "number" then
        local syncThresh = options.numberSyncThreshold or constants.DEFAULT_NUMBER_SYNC_THRESHOLD
        return abs(compVal - lastVal) >= syncThresh
    end
    return compVal ~= lastVal
end



local function registerNewComponent(compName)
    if compsBeingSynced[compName] then
        error("This component is already being synced: " .. tostring(compName))
    end
    compsBeingSynced[compName] = true
end



local function getRequiredComponents(compName, options)
    local requiredComponents = {compName}
    local extraComps = options.requiredComponents or EMPTY
    for _, comp in ipairs(extraComps)do
        table.insert(requiredComponents, comp)
    end
    return requiredComponents
end










local function trySendServerPacket(ent, eventSyncName, compName, options)
    local compVal = ent[compName]
    local deltaStore = options.deltaStore

    if deltaStore then
        local lastVal = deltaStore[ent]
        if not isDifferent(compVal, lastVal, options) then
            return -- The values are not different enough to warrant a sync.
        end
    end

    -- gotta do explicit nil check, to ensure `false` will get synced
    if (compVal ~= nil) or (options.syncWhenNil) then
        -- update component.
        server.broadcast(eventSyncName, ent, compVal)
        if deltaStore then
            deltaStore[ent] = compVal
        end
    end
end




local function setupSender(compName, sendFunc, options)
    --[[
        sets up a sender loop that continuously sends updates
        for a component, given a `sendFunc`.
    ]]
    local requiredComponents = getRequiredComponents(compName, options)

    if not options.noDeltaCompression then
        -- deltaStore is used for delta compression.
        options.deltaStore = {--[[
            [ent] -> last_seen_comp_value
        ]]}
    end

    local group = umg.group(unpack(requiredComponents))
    local eventSyncName = makeSyncName(compName)

    umg.on("@tick", function()
        for _, ent in ipairs(group) do
            sendFunc(ent, eventSyncName, compName, options)
        end
    end)
end








--[[
    used for bidirectional communication, 
    for controllable entities.
]]
local function trySendClientPacket(ent, eventSyncName, compName, options)
    local clientId = client.getUsername()
    if not isControlledBy(ent, clientId) then
        -- If we aren't controlling this entity, return.
        return
    end

    local compVal = ent[compName]
    local deltaStore = options.deltaStore

    if deltaStore then
        local lastVal = deltaStore[ent]
        if not isDifferent(compVal, lastVal, options) then
            return -- The values are not different enough to warrant a sync.
        end
    end

    -- gotta do explicit nil check, to ensure `false` will get synced
    if (compVal ~= nil) or (options.syncWhenNil) then
        -- update component.
        client.send(eventSyncName, ent, compVal)
        if deltaStore then
            deltaStore[ent] = compVal
        end
    end
end











--[[
    Clientside lerping.

    The way this works, is we receive a number value for a component
    from the server, and we automatically LERP to the new value
    slowly over the next frame.
    This makes things more delayed on the client, but it also
    makes stuff a lot smoother.
]]


function setLerpValue(ent, compName, compVal, options)
    local lerpValues = options.lerpValues
    local previousLerpValues = options.previousLerpValues

    if lerpValues[ent] then
        -- If there's a lerp value that we are currently lerping,
        -- set the entity comp value to that value.
        -- (i.e.  "jump" to the old value directly)
        local oldValue = lerpValues[ent]
        ent[compName] = oldValue
    else
        -- Else there's no old value, so just jump directly to the sent value.
        -- (This should only happen when an entity is first created.)
        ent[compName] = compVal
    end

    previousLerpValues[ent] = ent[compName]
    lerpValues[ent] = compVal
end



local getTickDelta = tickDelta.getTickDelta
local getTimeOfLastTick = tickDelta.getTimeOfLastTick


local function getLerpValue(oldVal, targetVal, t)
    local delta = (targetVal - oldVal) * (1-t)

    return targetVal - delta
end



local function setupClientNumberLerper(compName, options)
    --[[
        creates a lerp buffer that keeps track of all entity lerp values,
        and automatically lerps their values per frame.
    ]]
    assert(client, "Should only be called on client side!")
    local requiredComponents = getRequiredComponents(compName, options)
    local group = umg.group(unpack(requiredComponents))

    local previousLerpValues = {--[[
        [ent] -> previous lerp value
    ]]}
    local lerpValues = {--[[
        [ent] -> previous lerp value
    ]]}
    options.lerpValues = lerpValues
    options.previousLerpValues = previousLerpValues

    group:onRemoved(function(ent)
        -- ensure to clear lerp buffer when entities are removed
        lerpValues[ent] = nil
        previousLerpValues[ent] = nil
    end)

    umg.on("@update", function()
        local time = love.timer.getTime()
        local t = min(1, max(0, (time - getTimeOfLastTick()) / getTickDelta()))
        for _, ent in ipairs(group) do
            if lerpValues and lerpValues[ent] then
                local oldVal = previousLerpValues[ent]
                local targetVal = lerpValues[ent]
                ent[compName] = getLerpValue(oldVal, targetVal, t)
            end
        end
    end)
end




local function syncComponentClient(ent, compName, compVal, options)
    if options.lerp and type(compVal) == "number" then
        setLerpValue(ent, compName, compVal, options)
    else
        ent[compName] = compVal
    end
end



local function setupClientBidirectionalReceiver(compName, options)
    --[[
        sets up a bidirectional receiver:
        Packets are discarded if the entity in question is being controlled
        by the client.
        This is to avoid the player being sent outdated packets.
    ]]
    local eventSyncName = makeSyncName(compName)
    local shouldForceSync = options.bidirectional.shouldForceSyncClientside
    local userId = client.getUsername()

    client.on(eventSyncName, function(ent, compVal)
        if isControlledBy(ent, userId) then
            -- then discard the packet!
            -- This entity is being controlled; we don't want to lag them backwards.
            if shouldForceSync(ent, compVal) then
                ent[compName] = compVal
            end
        else
            syncComponentClient(ent, compName, compVal, options)
        end
    end)
end







local function setupClientReceiver(compName, options)
    --[[
        receives packets from server.
    ]]
    local eventSyncName = makeSyncName(compName)

    if options.bidirectional then
        setupClientBidirectionalReceiver(compName, options)

    else -- setup normally:
        client.on(eventSyncName, function(ent, compVal)
            syncComponentClient(ent, compName, compVal, options)
        end)
    end

end








local function setupServerReciever(compName, options)
    --[[
        receives packets from server
    ]]
    local eventSyncName = makeSyncName(compName)
    local shouldAcceptServerside = options.bidirectional.shouldAcceptServerside
    server.on(eventSyncName, {
        arguments = {filters.controlEntity, filters.any},
        handler = function(sender, ent, compVal)
            if shouldAcceptServerside(ent, compVal) then
                ent[compName] = compVal
            end
        end
    })
end






local function autoSyncComponent(compName, options)
    --[[
        NOTE: This function MUST be called within a shared context
            to work properly!!! (i.e, it must be called on BOTH client/server)
    ]]
    registerNewComponent(compName)

    options = options or {}
    for opt, _ in pairs(options)do
        assert(VALID_OPTIONS[opt], "Invalid sync option: " .. tostring(opt))
        if options.bidirectional then
            local optbid = options.bidirectional
            assert(optbid.shouldForceSyncClientside, "missing shouldForceSyncClientside callback!")
            assert(optbid.shouldAcceptServerside, "missing shouldAcceptServerside callback!")
        end
    end

    if server then
        if options.bidirectional then
            setupServerReciever(compName, options)
        end
        setupSender(compName, trySendServerPacket, options)

    else -- clientside:
        if options.bidirectional then
            setupSender(compName, trySendClientPacket, options)
        end

        setupClientReceiver(compName, options)

        if options.lerp then
            setupClientNumberLerper(compName, options)
        end
    end
end



return autoSyncComponent
