


local function craftOnClick(inv)
    assert(client, "this should only be called clientside")
    local ent = inv.owner
    if not umg.exists(ent) then
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





--[[
    abstract crafting entity.
]]
local abstractCrafter = {
    "inventory", "x", "y",

    craftItemLocation = {5,2},
    craftButtonLocation = {4,2},

    inventoryButtons = {
        [{4,2}] = defaultCraftButton
    },

    inventoryCallbacks = {
        slotExists = defaultSlotExists
    },

    super = function(ent)
        if (type(ent.crafter) ~= "table") or (not ent.crafter.executeCraft) then
            error("craftable entities must be given a .crafter member")
        end
        
        if not ent.inventory then
            ent.inventory = items.Inventory({
                width = 6,
                height = 3
            })
        end
    end
}


return abstractCrafter

