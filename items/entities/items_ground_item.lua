
return {
    groundItem = true,

    init = function(e, x, y)
        e.x = x
        e.y = y
        e.inventory = items.Inventory({
            width = 1, height = 1
        })
        e.inventory:setup(e)
    end
}
