


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



-- ORIGINALLY:::   setInventoryHoldDirection
client.on("setItemHoldPosition", function(ent, itemEnt, lookX, lookY)
    ent.lookX = lookX
    ent.lookY = lookY
    ent.holdItem = itemEnt
    itemEnt.x = lookX
    itemEnt.y = lookY
end)




local control_turn_ents = umg.group(
    "faceDirection", "inventory", "controllable", "controller", "x", "y"
)


umg.on("gameUpdate", function(dt)
    for i=1, #control_turn_ents do
        local ent = control_turn_ents[i]
        if ent.controller == client.getUsername() then
            ent.faceDirection = getTurnDirection(ent)
        end
    end
end)



local controlInventoryGroup = umg.group("controllable", "controller", "inventory", "x", "y")

umg.on("tick", function(dt)
    for i, ent in ipairs(controlInventoryGroup) do
        if ent.controller == client.getUsername() then
            local inv = ent.inventory
            if inv then
                local hold_x, hold_y = inv.holding_x, inv.holding_y
                if hold_x and hold_y and inv:get(hold_x, hold_y) then
                    local hold_item = inv:get(hold_x, hold_y)
                    client.send("setInventoryHoldItemPosition", ent, ent.faceDirection, hold_x, hold_y, getLookDirection(ent))
                end
            end
        end
    end
end)






function itemHolding.onUseItem(item, holder_ent, ...)
    item.item_lastUseTime = base.getGameTime()
end



