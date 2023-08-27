

-- crafting table object:

local Crafter = objects.Class("chest_mod:Crafter")


function Crafter:addRecipe(ingredients, result)
    --[[
        TODO:
        We should check that recipes don't overlap
        with any previous existing recipes

        ingredients:
        {
            {ingredient = "item_A", count = 6}; 
            {ingredient = "item_cap", count = 1}
        }
        
        result:
        { 
            entity = "item_C";  <--- should be entity name
            count = 16
        }
    ]]
    assert(ingredients and result, "Crafter:addRecipe() expects ingredients and a result")

    local recipe = {
        ingredients = ingredients;
        result = result;
        ingredientCounts = {}
    }

    for _, ingre in ipairs(ingredients) do
        local name = ingre.ingredient
        local count = ingre.count
        assert(count >= 1, "Ingredient count can't be less than 1")
        if recipe.ingredientCounts[name] then
            error("Duplicate ingredient: " .. tostring(name))
        end
        local i2rl = self.ingredientToRecipeList[name] or objects.Array()
        i2rl:add(recipe)
        recipe.ingredientCounts[ingre.ingredient] = ingre.count or 1
        self.ingredientToRecipeList[name] = i2rl
    end

    self.recipes:add(recipe)
    recipe.index = #self.recipes
    assert(self.recipes[recipe.index] == recipe, "incorrect recipe index assigned")
end


function Crafter:init()
    self.recipes = objects.Array()
    self.ingredientToRecipeList = {}
end




local function recipeIngredientsOk(recipe, ingredientsToCounts)
    -- returns true if the recipe can be crafted with the following ingredients,
    -- false otherwise.
    for _, ing in ipairs(recipe.ingredients) do
        local itemName = ing.ingredient
        local count = ing.count
        if not (ingredientsToCounts[itemName] and count <= ingredientsToCounts[itemName]) then
            return false
        end
    end
    return true
end


local function getIngredientsToCounts(inventory)
    --[[
        returns a mapping:
        {itemName -> count}
        that can be used to check how many items are in an inv.
    ]]
    local ingredientsToCounts = {}
    for x=1, inventory.width do
        for y=1, inventory.height do
            local val = inventory:get(x, y)
            if val then
                local itemName = val.itemName
                local c = ingredientsToCounts[itemName] or 0
                ingredientsToCounts[itemName] = c + (val.stackSize or 1)
                -- recall that default stackSize for items is 1, if nil.
            end
        end
    end
    return ingredientsToCounts
end


function Crafter:getResult(inventory)
    -- expects a flat array of ingredients.
    local ok = items.Inventory.isInstance(inventory)
    assert(ok, "Crafter:getResult(inv) takes an inventory as first argument!")
    
    local ingredientsToCounts = getIngredientsToCounts(inventory)

    for ingre, count in pairs(ingredientsToCounts) do
        local recipe_arr = self.ingredientToRecipeList[ingre]
        if recipe_arr then
            for _, recipe in ipairs(recipe_arr) do
                -- TODO: This might actually be quite slow, it could be faster
                -- to loop over all recipes
                if recipeIngredientsOk(recipe, ingredientsToCounts) then
                    return recipe
                end
            end
        end
    end
    return nil -- no recipe can be crafted.
end



local function removeIngredients(inventory, recipe)
    assert(server, "This shouldn't be called on clientside.")
    local ingredientsRemoved = {}

    for x=1, inventory.width do
        for y=1, inventory.height do
            local item = inventory:get(x,y)
            if item then
                local iname = item.itemName
                if recipe.ingredientCounts[iname] then
                    local tot_rem = ingredientsRemoved[iname] or 0
                    local amount = math.min(item.stackSize, recipe.ingredientCounts[iname] - tot_rem)
                    ingredientsRemoved[iname] = tot_rem + amount
                    item.stackSize = item.stackSize - amount
                    if item.stackSize == 0 then
                        item:delete()
                        inventory:remove(x,y)
                    end
                end
            end
        end
    end
end




local function initializeItem(inventory, recipe, slotX, slotY)
    local etype = server.entities[recipe.result.result]
    local item_entity = etype()
    local owner = inventory.owner
    if owner then
        if owner.x and owner.y then
            item_entity.x = owner.x
            item_entity.y = owner.y
        end
    end
    inventory:add(slotX, slotY, item_entity)
end


function Crafter:deny()
    -- todo: put something here
    print("recipe denied.")
end


function Crafter:tryCraft(inventory, slotX, slotY)
    local recipe = self:getResult(inventory)
    if recipe then
        self:executeCraft(inventory, recipe, slotX, slotY)
    else
        self:deny()
    end
end



function Crafter:getRecipeIndex(recipe)
    return recipe.index
end


function Crafter:getRecipeFromIndex(indx)
    return self.recipes[indx]
end




function Crafter:executeCraft(inventory, recipe, slotX, slotY)
    assert(inventory.drawHoverWidget, "Crafter:getResult(inv) takes an inventory as first argument!")
    assert(slotX and slotY, "ur not using this properly")    

    if client then -- crafting should be handled by the server.
        local recipeIndex = self:getRecipeIndex(recipe)
        client.send("tryCraftItem", inventory.owner, recipeIndex, slotX, slotY)
        return
    end

    local ingredientsToCounts = getIngredientsToCounts(inventory)

    if recipeIngredientsOk(recipe, ingredientsToCounts) then
        local targ = inventory:get(slotX, slotY)
        local targItemName, slotsLeft, etype
        if targ then 
            targItemName = targ.itemName
            slotsLeft = (targ.maxStackSize or 1) - (targ.stackSize or 1)
        end
        etype = server.entities[recipe.result.result]
        
        if etype then
            if (not targ) then 
                removeIngredients(inventory, recipe)
                initializeItem(inventory, recipe, slotX, slotY)
            elseif (targItemName == etype.itemName and slotsLeft >= recipe.result.count) then
                removeIngredients(inventory, recipe)
                targ.stackSize = targ.stackSize + (recipe.result.count or 1)
            else
                Crafter:deny()
            end
        else
            error("Unknown entity type for recipe: " .. tostring(recipe.result.result))
        end
    else
        Crafter:deny()
    end
end



return Crafter

