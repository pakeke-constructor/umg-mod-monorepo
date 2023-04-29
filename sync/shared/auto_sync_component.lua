

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



local function getRequiredComponents(compName, options)
    local requiredComponents = {compName}
    local extraComps = options.requiredComponents or EMPTY
    for _, comp in ipairs(extraComps)do
        table.insert(requiredComponents, comp)
    end
    return requiredComponents
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




local compNameToLerpBuffer = {--[[
    [compName] -> lerpBuffer

    where lerpBuffer = {
        [ent1] -> compVal
        [ent2] -> compVal
    }
]]}


local function setLerpValue(ent, compName, compVal)
    local lerpBuf = compNameToLerpBuffer[compName]
    if not lerpBuf[ent] then
        ent[compName] = compVal
    end

    lerpBuf[ent] = compVal
end




local lastTickDelta = 1/20
local timeOfLastTick = love.timer.getTime()

umg.on("@tick", function(dt)
    local time = love.timer.getTime()
    lastTickDelta = time - timeOfLastTick
    timeOfLastTick = time
end)


local function updateEntityWithLerp(ent, compName, targetVal)
    local currVal = ent[compName]
    local delta = (targetVal - currVal)

    ent[compName] = ent[compName] + delta
end


local function setupLerp(compName, options)
    local requiredComponents = getRequiredComponents(compName, options)
    local group = umg.group(unpack(requiredComponents))

    umg.on("@update", function(dt)
        local lerpBuffer = compNameToLerpBuffer[compName]
        for _, ent in ipairs(group) do
            if lerpBuffer[ent] then
                local targetVal = lerpBuffer[ent]
                updateEntityWithLerp(ent, compName, targetVal)
            end
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
        setupLerp(compName, options)
    end
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
        setupClientSync(compName, options)
    end
end



return autoSyncComponent
