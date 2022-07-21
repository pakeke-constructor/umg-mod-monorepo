
-- crafting table object:


local Crafter = base.Class()


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
            result = "item_C";
            count = 16
        }

    ]]
    assert(ingredients and result, "Crafter:addRecipe() expects ingredients and a result")

    local recipe = {
        ingredients = ingredients;
        result = result
    }

    local seen = {}

    for _, ingre in ipairs(ingredients) do
        local name = ingre.ingredient
        local count = ingre.count
        assert(count >= 1, "Ingredient count can't be less than 1")
        if seen[name] then
            error("Duplicate ingredient: " .. tostring(name))
        end
        local i2rl = self.ingredientToRecipeList[name] or base.Array()
        i2rl:add(recipe)
        seen[name] = true
        self.ingredientToRecipeList[name] = i2rl
    end

    self.recipes:add(recipe)
end


function Crafter:init()
    self.recipes = base.Array()
    self.ingredientToRecipeList = {}
end




local function recipeIngredientsOk(recipe, ingredientsToCounts)
    -- returns true if the recipe can be crafted with the following ingredients,
    -- false otherwise.
    for _, ing in ipairs(recipe.ingredients) do
        local itemName = ing.ingredient
        local count = ing.count
        if not (ingredientsToCounts[itemName] and count >= ingredientsToCounts[itemName]) then
            return false
        end
    end
    return true
end



function Crafter:getResult(inventory)
    -- expects a flat array of ingredients.
    assert(inventory.drawHoldWidget, "Crafter:getResult(inv) takes an inventory as first argument!")
    
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

    for ingre, count in pairs(ingredientsToCounts) do
        local arr = self.ingredientToRecipeList[ingre]
        if arr then
            for _, recipe in ipairs(arr) do
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




return Crafter

