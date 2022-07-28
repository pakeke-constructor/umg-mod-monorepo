


local function assertNoDuplicate(buttons, x, y)
    for loc, _ in pairs(buttons) do
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

    local itemX = ent.craftItemLocation[1]
    local itemY = ent.craftItemLocation[2]    
    ent.crafter:tryCraft(inv, itemX, itemY)
end


local function defaultSlotExists(_, x,y)
    if x <= 3 or (x==5 and y==2) then
        return true
    else
        return false
    end
end


local defaultCraftButton = {
    onClick = craftOnClick;
    image = "craft_icon"
}


local function newCraftingTable(ent_template)
    --[[
        returns a crafting-table like entity
    ]]
    if (type(ent_template.crafter) ~= "table") or (not ent_template.crafter.executeCraft) then
        error("craftable entities must be given a .crafter member")
    end

    ent_template.craftItemLocation = ent_template.craftItemLocation or {5,2}
    ent_template.craftButtonLocation = ent_template.craftButtonLocation or {4,2}

    local itemX = ent_template.craftItemLocation[1]
    local itemY = ent_template.craftItemLocation[2]

    local buttonX = ent_template.craftButtonLocation[1]
    local buttonY = ent_template.craftButtonLocation[2]

    assert(buttonX and buttonY, "craftable not given button location")
    assert(itemX and itemY, "craftable not given item location")
    assert(buttonX ~= itemX or buttonY ~= itemY, "button and item location cant be in the same position")

    local invCbs = ent_template.inventoryCallbacks or {}
    local invButtons = ent_template.inventoryButtons or {}
    assertNoDuplicate(invButtons, itemX, itemY)
    assertNoDuplicate(invButtons, buttonX, buttonY)
    invButtons[ent_template.craftButtonLocation] = defaultCraftButton

    ent_template.inventoryButtons = invButtons
    ent_template.inventoryCallbacks = invCbs

    if not ent_template.inventory then
        table.insert(ent_template, "inventory")
        invCbs.slotExists = defaultSlotExists
        local oldInit = ent_template.init
        ent_template.init = function(ent, ...)
            ent.inventory = {
                width = 6;
                height = 3
            }
            if oldInit then oldInit(ent, ...) end
        end
    end

    return ent_template
end


return newCraftingTable

