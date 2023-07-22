
--[[

Automatic component syncing facilities.

usage:

sync.autoSyncComponent(<compName>, options)


Options allows us to configure delta compression, extra components required,
lerp for clientside to make number changes more smooth, etc.


------------------------------------------

Example with all options:

sync.autoSyncComponent("x", {
    lerp = true, -- whether we lerp numbers
    numberSyncThreshold = 0.5, -- threshold for numbers to be lerped
    requiredComponents = {"vx"}, -- extra required components for sync
    noDeltaCompression = false, -- 

    syncWhenNil = true,

    controllable = {
        shouldAcceptServerside = function()

        end,
        shouldForceSyncClientside = function()

        end
    }
})

]]

local constants = require("constants")

local helper = require("shared.auto_sync_helper")

local isControllable = require("shared.is_controllable")


local VALID_OPTIONS = {
    syncWhenNil = true,
    lerp = true,
    noDeltaCompression = true,
    numberSyncThreshold = true,
    requiredComponents = true,
    controllable = true
}




local abs = math.abs
local type = type
local max, min = math.max, math.min




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
        over the network.
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
    used for controllable entities.
]]
local function trySendClientPacket(ent, eventSyncName, compName, options)
    local clientId = client.getUsername()
    if not isControllable(ent, clientId) then
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









local function setupClientSender(compName, options)
    --[[
        sends packets to server to update controllable entities
    ]]
    local requiredComponents = getRequiredComponents(compName, options)

    if not options.noDeltaCompression then
        options.deltaStore = {--[[
            [ent] -> last_seen_comp_value
        ]]}
    end

    local group = umg.group(unpack(requiredComponents))
    local eventSyncName = makeSyncName(compName)
    umg.on("@tick", function()
        for _, ent in ipairs(group) do
            trySendServerPacket(ent, eventSyncName, compName, options)
       end
    end)
end



local function setupClientReceiver(compName, options)
    --[[
        receives packets from server
    ]]
    local eventSyncName = makeSyncName(compName)
    client.on(eventSyncName, function(ent, compVal)
        if options.lerp and type(compVal) == "number" then
            setLerpValue(ent, compName, compVal)
        else
            ent[compName] = compVal
        end
    end)

    if options.lerp then
        setupClientNumberLerper(compName, options)
    end
end



local function autoSyncComponent(compName, options)
    --[[
        NOTE: This function MUST be called within a shared context
            to work properly!!! (i.e, it must be called on BOTH client/server)
    ]]
    helper.registerNewComponent(compName)

    options = options or {}
    for opt, _ in pairs(options)do
        assert(VALID_OPTIONS[opt], "Invalid sync option: " .. tostring(opt))
    end

    if server then
        setupSender(compName, trySendServerPacket, options)
    else
        if options.controllable then
            setupSender(compName, trySendClientPacket, options)
        end
        setupClientReceiver(compName, options)
    end
end



return autoSyncComponent
