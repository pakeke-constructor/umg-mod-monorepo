


client.on("setInventoryHoldItem", function(ent, item)
    if ent.holdItem then -- hide existing hold item
        ent.holdItem.hidden = true
    end
    if item then -- unhide new hold item
        item.hidden = false
    end
    ent.holdItem = item
end)




