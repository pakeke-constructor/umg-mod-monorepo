

local sf = sync.filters

server.on("tryCraftItem", {
    arguments = {sf.entity, sf.number, sf.number, sf.number},

    handler = function(sender, ent, recipeIndex, slotX, slotY)
        --[[
            TODO: Assert that `sender` has access to `ent`s inventory.
        ]]
        if not umg.exists(ent) then return end
        if not (ent.crafter) then return end
        if not (ent.inventory) then return end
        if type(recipeIndex) ~= "number" then return end
        if type(slotX) ~= "number" then return end
        if type(slotY) ~= "number" then return end
        -- Todo- probably need to check if slotx and slotY are valid inventory positions

        local recipe = ent.crafter:getRecipeFromIndex(recipeIndex)
        if recipe then
            ent.crafter:executeCraft(ent.inventory, recipe, slotX, slotY)
        end
    end
})



