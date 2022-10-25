

--[[

This module allows us to define what our components look like.


]]


local components = {}


local compNameToCompInfo = {
    --[[
        [compName] = <compInfo table>
        -- (see components.defineComponent)
    ]]
}



local validTypes = {
    ["function"]=true,
    ["number"]=true,
    ["boolean"]=true,
    ["string"]=true,
    ["entity"]=true
}

local validKinds = {
    ["regular"] = true,
    ["shared"] = true,
    ["both"] = true
}


local function deepSearchFor(tabl, x, seen)
    seen = seen or {}
    if seen[tabl] then
        return false
    end
    seen[tabl] = true
    for k,v in pairs(tabl) do
        if v == x then
            return true, k
        elseif type(v) == "table" then
            local result = deepSearchFor(v, x, seen)
            if result then
                return true, k
            end
        end
    end
    return false
end




local function doChecks(compName, compInfo)
    -- checking stuff is valid
    assert(type(compName) == "string", "compName must be a string")
    assert(type(compInfo) == "table", "compInfo must be a table")
    assert(compInfo.type and validTypes[compInfo.type], "Invalid type for compInfo: " .. compInfo.type)
    assert(compInfo.kind and validKinds[compInfo.kind], "Invalid component kind for compInfo: " .. compInfo.kind)
    assert((not compInfo.description) or type(compInfo.description) == "string", "compInfo.description must be a string")
    if compInfo.type == "function" then
        assert(compInfo.kind == "shared", "function components must be shared. (This is because lua functions can't be serialized.)")
    end
    if compInfo.type == "table" then
        assert(compInfo.table, "table components must have a .table definition. (See components.lua for example)")
        if compInfo.kind ~= "shared" then
            local funcExists, key = deepSearchFor(compInfo.table, "function")
            if funcExists then
                error("table is a regular component, but has a function inside of it. Components with functions embedded in them cannot be shared. The key with the function is: " .. tostring(key))
            end
        end
    end
end




function components.defineComponent(compName, compInfo)
    --[[
        example: 
        
        compName = "myComponent",

        compInfo = {
            type = "table",
            kind = "regular" or "shared"
            description = "my component!",

            -- This is ONLY needed if type="table"; 
            -- it gives information about what the table should look like.
            table = {
                -- nested tables are allowed!
                friends = {
                    friend1 = "entity",
                    friend2 = "entity"
                },

                my_num = "number",
                my_str = "string"
            }
        }
    ]]
    doChecks(compName, compInfo)
    compNameToCompInfo[compName] = compInfo
end



function components.getComponentInfo(compName)
    assert(type(compName) == "string", "compName should be a string")
    return compNameToCompInfo[compName]
end




return components

