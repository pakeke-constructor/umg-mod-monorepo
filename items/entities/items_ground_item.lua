

local GroundItemInventory = objects.Class("items:GroundItemInventory")

function GroundItemInventory:onItemAdded()

end


return {
    groundItem = true,
    spinning = {},

    init = function(e, x, y)
        e.x = x
        e.y = y
        e.inventory = items.Inventory({
            width = 1, height = 1
        })
        e.inventory:setup(e)
    end
}
