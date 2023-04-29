

local constants = require("shared.constants")


local VALID_OPTIONS = {
    syncWhenNil = true,
    lerp = true,
    noDeltaCompression = true,
    numberSyncThreshold = 0.1,
    requiredComponents = true,
}


local EMPTY = {}




local EVENT_PREFIX = "_sync_"


local compsBeingSynced = {
    --[[
        [compName] -> true/false
        whether this component is being auto synced or not.
    ]]
}



local function makeSyncName(compName)
    return EVENT_PREFIX .. compName
end



local abs = math.abs
local type = type

local function isDifferent(compVal, lastVal, options)
    if type(compVal) == "number" and type(lastVal) == "number" then
        return abs(compVal - lastVal) <= options.numberSyncThreshold
    end
    return compVal ~= lastVal
end



local function serverSyncEntity(ent, eventSyncName, compName, options)
    local compVal = ent[compName]
    -- gotta do explicit nil check, to ensure `false` will get synced
    if options.deltaStore then
        local lastVal = options.deltaStore[ent]
        if not isDifferent(compVal, lastVal, options) then
            return -- The values are not different enough to warrant a sync.
        end
    end
    if (compVal ~= nil) or (options.syncWhenNil) then
        server.broadcast(eventSyncName, ent, compVal)
    end
end


local function setupServerSync(compName, options)
    local requiredComponents = {compName}
    local extraComps = options.requiredComponents or EMPTY
    for _, comp in ipairs(extraComps)do
        table.insert(requiredComponents, comp)
    end

    options.deltaStore = {--[[
        [ent] -> last_seen_comp_value
    ]]}

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
        -- TODO: Do auto-lerp for numbers on clientside here
        ent[compName] = compVal
    end)
end


local function autoSyncComponent(compName, options)
    --[[
        NOTE: This function MUST be called within a shared context
            to work properly!!! (i.e, it must be called on BOTH client/server)
    ]]
    assert(not compsBeingSynced[compName], "This component is already being synced!")
    compsBeingSynced[compName] = true

    options = options or {}
    for opt, _ in pairs(options)do
        assert(VALID_OPTIONS[opt], "Invalid sync option: " .. tostring(opt))
    end

    if server then
        setupServerSync(compName, options)
    else

    end
end

