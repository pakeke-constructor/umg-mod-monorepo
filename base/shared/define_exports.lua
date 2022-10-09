
--[[

What is this used for?
Why can't we just use `export("my_module", module)` to export modules normally?

We *CAN* do that, sure.
However, doing it this way will automatically generate nice errors if you 
accidentally use a server-only function on clientside, (or vice versa.)

Without this module, we just get "attempt to call a nil value" which isn't
very nice.


]]




local function addErrorFuncsToModule(illegal_module, module, err_func)
    for key, val in pairs(illegal_module) do 
        if type(key) == "number" and type(val) == "string" then
            -- then we are dealing with a function: set it to err_func
            -- (make sure we don't overwrite anything.)
            local funcName = val
            module[funcName] = module[funcName] or err_func
        elseif type(key) == "string" and type(val) == "table" then
            -- its a nested module.
            module[key] = module[key] or {}
            addErrorFuncsToModule(val, module[key], err_func)
        end
    end
end


local function makeIllegal(illegal_api, err_func)
    --[[
        illegal_api is in the form:
        illegal_api = {
            module1 = {"func1", "func2", "func3"},
            module2 = {
                "func1",
                nested_module = {"nfunc1","nfunc2"}
            }
        }
    ]]
    for name, illegal_module in pairs(illegal_api) do
        assert(type(name) == "string", "invalid format")
        local module = {}
        if not _G[name] then
            export(name, module)
        end
        addErrorFuncsToModule(illegal_module, module, err_func)
    end
end



local function mergeExportDefinition(sideOnlyExports, module, module_name, seen)
    --[[
        merges a module into the sideOnlyExports, (without including the actual functions.)
    
        This allows sideOnlyExports to be sent over the network, which allows
        server/client side to generate the appropriate error functions.
    ]]
    seen = seen or {} -- ensures no infinite recursion
    sideOnlyExports[module_name] = sideOnlyExports[module_name] or {}
    for key, value in pairs(module) do
        if not seen[value] then
            if type(value) == "table" then
                -- we merge nested
                mergeExportDefinition(sideOnlyExports[module_name], value, key, seen)
            else
                -- usually, `value` will be a function; but we can't guarantee it.
                table.insert(sideOnlyExports[module_name], key)
            end
            seen[value] = true
        end
    end
end



local serverSideOnlyExports, clientSideOnlyExports

if server then

local serverSideErrStr =
[[
This function works client-side only, but you called it on server-side.

HINT:  Callbacks, like onUpdate or onClick, are called on BOTH server and client.
You may want to have a check:
if client then 
    funcName(...)
end
This ensures that the code is only ran on clientside.
]]

local function serverError()
    error(serverSideErrStr, 2)
end

local needsClientExports = true
serverSideOnlyExports = {}


on("playerJoin", function(username)
    server.unicast(username, "defineServerOnlyAPI", serverSideOnlyExports, needsClientExports)
end)


server.on("defineClientOnlyAPI", function(username, clientOnlyAPI)
    --[[
        this is guaranteed to be the first player to join (i.e. the host)
        so we can trust the data. The host won't want to crash their own server.
    ]]
    if not needsClientExports then
        return
    end
    needsClientExports = false
    -- make clientside functions illegal on serverside
    makeIllegal(clientOnlyAPI, serverError)
end)


elseif client then

local clientSideErrStr =
[[
This function works server-side only, but you called it on client-side.

HINT:  Callbacks, like onUpdate or onClick, are called on BOTH client and server.
You may want to have a check:
if server then 
    funcName(...)
end
This ensures that the code is only ran on serverside.
]]

clientSideOnlyExports = {}

local function clientError()
    error(clientSideErrStr, 2)
end


client.on("defineServerOnlyAPI", function(serverSideOnlyAPI, needsClientExports)
    -- make serverside functions illegal on clientside.
    makeIllegal(serverSideOnlyAPI, clientError)

    if needsClientExports then
        -- And if the server needs to know what clientside functions there are,
        -- send these guys over.
        client.send("defineClientOnlyAPI", clientSideOnlyExports)
    end
end)


end




local function loadServer(options, api)
    assert((not client) and server, "this shouldnt be called on clientside")
    if options.loadShared then
        options.loadShared(api)
    end
    if options.loadServer then
        local seAPI = {}
        options.loadServer(seAPI)
        if serverSideOnlyExports[options.name] then
            error("Overwriting an existing export: " .. options.name)
        end
        -- Record server functions so the client can know about them eventually
        mergeExportDefinition(serverSideOnlyExports, seAPI, options.name)
        -- now put the functions in the actual exported api
        for k,v in pairs(seAPI) do
            api[k] = v
        end    
    end
end


local function loadClient(options, api)
    assert((not server) and client, "this shouldnt be called on server-side")
    if options.loadShared then
        options.loadShared(api)
    end
    if options.loadClient then
        local clAPI = {}
        options.loadClient(clAPI)
        if clientSideOnlyExports[options.name] then
            error("Overwriting an existing export: " .. options.name)
        end
        -- Record client functions so the server can know about them eventually
        mergeExportDefinition(clientSideOnlyExports, clAPI, options.name)
        -- now put the functions in the actual exported api
        for k,v in pairs(clAPI) do
            api[k] = v
        end    
    end
end




local function defineExports(options)
    assert(type(options) == "table", "defineOptions requires a table as first arg")
    assert(options.name, "defineExports(options) requires a .name value")

    if client then
        local api = {}
        loadClient(options, api)
        export(options.name, api)
    elseif server then
        local api = {}
        loadServer(options, api)
        export(options.name, api)
    end
end

return defineExports


