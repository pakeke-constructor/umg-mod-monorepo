
require("shared.constants")

local Board
if server then
    Board = require("server.board")
end


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



local textArg = {Color = constants.ABILITY_UI_COLORS.TARGET}

function Target:drawSlabUI()
    local txt = self.description
    Slab.Text("Target: ", textArg)
    Slab.SameLine()
    Slab.Text(txt)
end


function Target:getTargetEntities(sourceEnt)
    return self.getTargets(sourceEnt)
end


local function getAllies(sourceEnt)
    --[[
        gets all allies, excluding `self`.
    ]]
    local board = Board.getBoard(sourceEnt.rgbTeam)
    local allies = board:getUnits()
    for i=allies:size(), 1, -1 do
        local ent = allies[i]
        if ent == sourceEnt then
            -- Remove `self` from allies array
            allies:quickPop(i)
        end
    end
    return allies
end


-- allies:
-- all allies.
Target({
    name = "allies",
    getTargets = function(sourceEnt)
        return getAllies(sourceEnt)
    end,
    description = "All allies"
})

-- self
-- Affects self
Target({
    name = "self",
    getTargets = function(sourceEnt)
        return {sourceEnt}
    end,
    description = "Self"
})


-- matching
-- all same color allies
Target({
    name = "matching",
    getTargets = function(sourceEnt)
        return getAllies(sourceEnt):filter(function(ent)
            return rgb.match(ent.rgb, sourceEnt.rgb)
        end)
    end,
    description = "Matching allies"
})


-- different
-- all different color allies
Target({
    name = "different",
    getTargets = function(sourceEnt)
        return getAllies(sourceEnt):filter(function(ent)
            return not rgb.match(ent.rgb, sourceEnt.rgb)
        end)
    end,
    description = "Non-matching allies"
})



--[[
    Creating a bunch of targets to target each ally type.

    sorcererAllies
    meleeAllies
    rangedAllies

    etc
]]
for _, enum in ipairs(constants.UNIT_TYPES)do
    local enumLowered = enum:lower() 

    local function filter(ent)
        return rgb.isUnitOfType(ent, enum)
    end

    local postFix = "Allies"
    Target({
        name = enumLowered .. postFix,
        getTargets = function(sourceEnt)
            return getAllies(sourceEnt):filter(filter)
        end,
        description = enumLowered .. " allies"
    })
end




return targets

