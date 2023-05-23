

local filters = {}

local Filter = base.Class("rgb-chess:Filter")


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




function Filter:drawSlabUI()
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
    description = "If the target has more health than me"
})



Filter({
    name = "hasLessHealth",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.health < targetEnt.health
    end,
    description = "If the target has less health than me"
})


Filter({
    name = "hasMoreDamage",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.damage > targetEnt.damage
    end,
    description = "If the target has more damage than me"
})



Filter({
    name = "hasLessDamage",
    filter = function(sourceEnt, targetEnt)
        return sourceEnt.damage < targetEnt.damage
    end,
    description = "If the target has less damage than me"
})




Filter({
    name = "hasInventorySpace",
    filter = function(sourceEnt, targetEnt)
        return targetEnt.inventory and targetEnt.inventory:getEmptySlot()
    end,
    description = "If the target has inventory space"
})



Filter({
    name = "hasInventory",
    filter = function(sourceEnt, targetEnt)
        return targetEnt.inventory
    end,
    description = "If the target has an inventory"
})



for enum, _ in pairs(constants.UNIT_TYPES) do
    local upperName = enum:sub(1,1):upper() .. enum:sub(2):lower()

    Filter({
        name = "is" .. upperName,
        filter = function(sourceEnt, targetEnt)
            return rgb.isUnitOfType(targetEnt, constants.UNIT_TYPES[enum])
        end,
        description = "If the target is a " .. upperName
    })
end



return filters
