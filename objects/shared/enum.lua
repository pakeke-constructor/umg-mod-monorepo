

local function has(self, k)
    return rawget(self, k)
end



local ENUM_MT = {
    __index = function(t,k)
        error("Attempt to access undefined enum value: " .. k, 2)
    end,
    __newindex = function(t,k,v)
        error("Attempt to edit a constant enum", 2)
    end
}


umg.register(ENUM_MT, "objects:Enum")


local function assertString(x)
    if type(x) ~= "string" then
        error("Enum values must be strings", 3)
    end
end

local function newEnum(values)
    local enum = {}
    for _, v in ipairs(values) do
        enum[v] = v
        assertString(v)
    end

    for k,v in pairs(values) do
        if type(k) ~= "number" then
            assertString(v)
            enum[v] = v
        end
    end

    --[[
        we probably want more useful enum methods here.
    ]]
    enum.has = has

    return setmetatable(enum, ENUM_MT)
end


return newEnum

