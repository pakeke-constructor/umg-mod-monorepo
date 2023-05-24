

--[[

sync.syncComponent(ent, compName)


Manually syncs a component directly.
Uses string -> id compression to compress the component name.


]]


local currentId = 0

local componentIdCache = {--[[
    [id] -> compName
    [compName] -> id

    compresses component names to ids, for easy access.
]]}


if client then

client.on("setSyncComponentCache", function(cache)
    componentIdCache = cache
end)

client.on("syncComponent", function(ent, id, compValue)
    local compName = id
    ent[compName] = compValue
end)

end





if server then

local function updateCompIdCache()
    --[[
        dear future Oli:
        pls dont hate me if there's a desync because of this
    ]]
    server.broadcast("setSyncComponentCache", componentIdCache)
end

umg.on("@join", function()
    updateCompIdCache()
end)


local function addEntry(compName)
    currentId = currentId + 1
    local compId = currentId
    componentIdCache[compId] = compName
    componentIdCache[compName] = compId
end


local function getComponentId(compName)
    if not componentIdCache[compName] then
        addEntry(compName)
        updateCompIdCache()
    end
    return componentIdCache[compName]
end


local syncComponentTc = typecheck.assert("entity", "string")

local function syncComponent(ent, compName)
    syncComponentTc(ent, compName)

    local id = getComponentId(compName)
    server.broadcast("syncComponent", ent, id, ent[compName])
end

return syncComponent

end


