


server.on("tryCraftItem", function(ent, recipeIndex, slotX, slotY)
    if not exists(ent) then return end
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
end)



