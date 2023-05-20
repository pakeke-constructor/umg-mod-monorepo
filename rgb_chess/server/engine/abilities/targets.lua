

local targets = {}

local Target = base.Class("rgb-chess:Target")


local nameToTarget = {--[[
    [name] = Target
]]}


function targets.getTarget(name)
    return nameToTarget[name]
end



function Target:init(options)
    assert(options.name, "?")
    assert(options.getTargets, "?")
    assert(options.description, "?")
    local tdes = type(options.description)
    assert(tdes == "string" or tdes == "function", "?")

    assert(not nameToTarget[options.name], "duplicate target def")
    nameToTarget[options.name] = self

    for k,v in pairs(options)do
        self[k] = v
    end
end



function Target:drawSlabUI()
    local txt = self.description
    Slab.Text(txt)
end


function Target:getTargets(sourceEnt)
    return self.getTargets(sourceEnt)
end


local function getAllies(board)
    local buffer = base.Array()
    for _, ent in board:iterUnits() do
        buffer:add(ent)
    end
    return buffer
end


Target({
    name = "allies",
    getTargets = function(board)
        return getAllies(board)
    end,
    description = "For all allies:"
})





for _, enum in ipairs(constants.UNIT_TYPES)do
    local postFix = "Allies"
    local enumLowered = enum:lower() 

    local function filter(ent)
        return rgb.isUnitOfType(ent, enum)
    end

    Target({
        name = enumLowered .. postFix,
        getTargets = function(board)
            return getAllies(board):filter(filter)
        end,
        description = "For all " .. enumLowered .. " allies:"
    })
end







return targets

