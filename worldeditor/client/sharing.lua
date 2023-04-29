


local sharing = {}


local packageTypes = {
    TOOL = "TOOL",
    SCHEMATIC = "SCHEMATIC",
    HOTKEYS = "HOTKEYS"
}


sharing.packageTypes = packageTypes


--[[
    imports an object type from clipboard
]]
function sharing.import(base64_string)
    if base64_string:find("\n") then
        -- we remove the first \n to remove the header
        local i = base64_string:find("\n[^\n]*$")
        base64_string = base64_string:sub(i+1)
    end

    local success, data = pcall(love.data.decode, "string","base64",base64_string)
    if not success then
        return nil, "couldn't decode base64"
    end

    success, data = pcall(love.data.decompress, "string","zlib", data)
    if not success then
        return nil, "couldn't decompress data"
    end
    
    local package, err = umg.deserialize(data)

    if package and type(package) == "table" then
        local type = package.type
        if (not type) or (not package.object) or (not packageTypes[type]) then
            return nil, "Unrecognized package type"
        end
        return package
    else
        return nil, "couldn't deserialize data: " .. err
    end
end





local assertExport = typecheck.assert("string", "table", "string")

--[[
    serializes an object type and copies it to clipboard
]]
function sharing.export(name, object, type)
    assertExport(name,object,type)
    assert(packageTypes[type], "unkknown type")
    local package = {
        object = object,
        type = type
    }
    local data = umg.serialize(package)
    data = love.data.compress("string","zlib",data)
    local str = love.data.encode("string","base64",data)

--[[ The reason we add the name to the string, 
    as opposed to putting the name in the package,
    is so that users can read what the tool actually is before
    importing it.   (i.e. name will show up in discord, for example)   ]]
    str = name .. "\n" .. str
    return str
end


function sharing.exportToClipboard(name, object, type)
    love.system.setClipboardText(sharing.export(name, object, type))
end



return sharing

