


client.on("setInventoryHoldItem", function(ent, item)
    if ent.controller == client.getUsername() then
        -- Ignore broadcasts for our own entities;
        -- We will have more up to date data.
        return 
    end

    if item then -- unhide hold item
        item.hidden = false
    end
    if ent.holdItem then -- hide hold item
        ent.holdItem.hidden = true
    end
    ent.holdItem = item
end)




