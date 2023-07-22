
--[[

Automatic component syncing facilities.

usage:

sync.autoSyncComponent(<compName>, options)


Can configure delta compression, extra components required for syncing,
lerp for clientside to make number changes more smooth


]]

local constants = require("constants")


local VALID_OPTIONS = {
    syncWhenNil = true,
    lerp = true,
    noDeltaCompression = true,
    numberSyncThreshold = true,
    requiredComponents = true,
}




local abs = math.abs
local type = type
local max, min = math.max, math.min

local function isDifferent(compVal, lastVal, options)
    if type(compVal) == "number" and type(lastVal) == "number" then
        local syncThresh = options.numberSyncThreshold or constants.DEFAULT_NUMBER_SYNC_THRESHOLD
        return abs(compVal - lastVal) >= syncThresh
    end
    return compVal ~= lastVal
end



local function serverSyncEntity(ent, eventSyncName, compName, options)
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




local function setupServerSync(compName, options)
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
            serverSyncEntity(ent, eventSyncName, compName, options)
       end
    end)
end

















local function setupClientSync(compName, options)
    local eventSyncName = makeSyncName(compName)
    client.on(eventSyncName, function(ent, compVal)
        if options.lerp and type(compVal) == "number" then
            setLerpValue(ent, compName, compVal)
        else
            ent[compName] = compVal
        end
    end)

    if options.lerp then
        setupClientNumberLerp(compName, options)
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
        setupServerSync(compName, options)
    else
        setupClientSync(compName, options)
    end
end



return autoSyncComponent
