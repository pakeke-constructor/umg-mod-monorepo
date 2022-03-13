
local invCtor = require("inventory")


local inv_ents = group("inventory")
-- group of all entities that have an `inventory` component.


inv_ents:on_added(function(ent)
    if not ent.inventory then
         -- Oh no! entity doesn't have a .inventory field yet.
        -- Lets try to initialize the entity.
        if ent.init then
            ent:init()
        end
        assert(ent.inventory, "Inventory component must be initialized either before entity creation, or inside a `.init` function!")
    end

    if not getmetatable(ent.inventory) then
        -- Then the inventory hasn't been initialized and we should init it.
        ent.inventory = invCtor(ent.inventory)
        ent.inventory.owner = ent
    end
end)



on("mainDrawUI", function()
    for i, ent in ipairs(inv_ents) do
        ent.inventory:drawUI()
    end
end)


