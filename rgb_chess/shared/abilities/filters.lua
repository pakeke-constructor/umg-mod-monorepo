
--[[

This file is where all the filters are defined


]]
require("shared.constants")


local filters = {}

local Filter = data.Class("rgb-chess:Filter")


local nameToFilter = {--[[
    [name] = Filter
]]}


function filters.getFilter(name)
    return nameToFilter[name]
end



function Filter:init(options)
    assert(options.name, "?")
    assert(options.filter, "?")
    assert(options.description, "?")

    assert(not nameToFilter[options.name], "duplicate filter def")
    nameToFilter[options.name] = self

    for k,v in pairs(options)do
        self[k] = v
    end
end



local textArg = {Color = constants.ABILITY_UI_COLORS.FILTER}

function Filter:drawSlabUI()
    Slab.Text("Filter: ", textArg)
    Slab.SameLine()
    Slab.Text(self.description)
end


function Filter:filter(...)
    return self.filter(...)
end





Filter({
    name = "hasMoreHealth",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.health > targetEnt.health
    end,
    description = "Target has more health than me"
})



Filter({
    name = "hasLessHealth",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.health < targetEnt.health
    end,
    description = "Target has less health than me"
})



Filter({
    name = "hasMorePower",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.power < targetEnt.power
    end,
    description = "If the target has more damage than me"
})



Filter({
    name = "hasLessPower",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.power > targetEnt.power
    end,
    description = "If the target has less damage than me"
})




--[[
    returns true if `ent` has an item that satisfies `func`
]]
local function hasItemWith(ent, func)
    local inv = ent.inventory
    if not inv then
        return
    end
    for x=1, inv.width do
        for y=1, inv.height do
            local item = inv:get(x,y)
            if umg.exists(item) and func(item) then
                return true
            end
        end
    end
    return false
end


Filter({
    name = "hasItem",
    filter = function(_sourceEnt, targetEnt)
        return hasItemWith(targetEnt, base.operators.TRUTHY)
    end,
    description = "Target has an item"
})

Filter({
    name = "hasActiveItem",
    filter = function(_sourceEnt, targetEnt)
        return hasItemWith(targetEnt, rgb.isUsableItem)
    end,
    description = "Target has an active item"
})

Filter({
    name = "hasPassiveItem",
    filter = function(_sourceEnt, targetEnt)
        return hasItemWith(targetEnt, rgb.isPassiveItem)
    end,
    description = "Target has a passive item"
})






Filter({
    name = "hasInventorySpace",
    filter = function(_sourceEnt, targetEnt)
        return targetEnt.inventory and targetEnt.inventory:getEmptySlot()
    end,
    description = "Target has inventory space"
})



Filter({
    name = "hasInventory",
    filter = function(sourceEnt, targetEnt)
        return targetEnt.inventory
    end,
    description = "Target has an inventory"
})



for enum, _ in pairs(constants.UNIT_TYPES) do
    local upperName = enum:sub(1,1):upper() .. enum:sub(2):lower()

    Filter({
        name = "is" .. upperName,
        filter = function(sourceEnt, targetEnt)
            return rgb.isUnitOfType(targetEnt, constants.UNIT_TYPES[enum])
        end,
        description = "Target is a " .. upperName
    })
end



return filters
