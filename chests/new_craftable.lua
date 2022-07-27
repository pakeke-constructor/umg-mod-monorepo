


local function assertNoDuplicate(buttons, x, y)
    for loc, button in pairs(buttons) do
        local bx = loc[1]
        local by = loc[2]
        if bx == x and by == y then
            error("Duplicate button position: " .. tostring(x) .. tostring(y))
        end
    end
end



local function craftOnClick(inv)
    assert(client, "this should only be called clientside")
    local ent = inv.owner
    if not exists(ent) then
        return -- ???? I guess we can't craft...?
    end
    local recipe = ent.crafter:getResult(inv)
    if recipe then
        local itemX = ent.craftItemLocation[1]
        local itemY = ent.craftItemLocation[2]    
        ent.crafter:tryCraft(inv, itemX, itemY)
    end
end


local defaultCraftButton = {
    onClick = craftOnClick;
    image = "craft_icon"
}


local function newCraftable(ent_template)
    if (type(ent_template.crafter) ~= "table") or (not ent_template.crafter.executeCraft) then
        error("craftable entities must be given a .crafter member")
    end

    local itemX = ent_template.craftItemLocation[1]
    local itemY = ent_template.craftItemLocation[2]

    local buttonX = ent_template.craftButtonLocation[1]
    local buttonY = ent_template.craftButtonLocation[2]

    assert(buttonX and buttonY, "craftable not given button location")
    assert(itemX and itemY, "craftable not given item location")
    assert(buttonX ~= itemX or buttonY ~= itemY, "button and item location cant be in the same position")

    local invCbs = ent_template.inventoryCallbacks or {}
    local buttons = invCbs.buttons or {}
    assertNoDuplicate(buttons, itemX, itemY)
    assertNoDuplicate(buttons, buttonX, buttonY)

    table.insert(buttons, {
        [ent_template.craftButtonLocation] = defaultCraftButton
    })
    ent_template.buttons = buttons

    return ent_template
end


return newCraftable

