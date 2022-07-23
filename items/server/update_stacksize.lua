

local function updateStackSize(item_ent)
    -- updates an item's stack Size to the client.

    -- Includes cheap and easy delta compression, at the cost of code cleanliness.
    -- (item_ent.previous_stackSize is a temporary value, not a component.
    --   it all feels very messy, I dont like it)
    -- At least the "messyness" is somewhat contained to this file
    if item_ent.stackSize ~= item_ent.previous_stackSize then
        item_ent.previous_stackSize = item_ent.stackSize
        server.broadcast("setInventoryItemStackSize", item_ent, item_ent.stackSize)        
    end
end


return updateStackSize

