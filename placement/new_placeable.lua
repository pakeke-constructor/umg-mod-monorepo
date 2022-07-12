--[[

creates a new buildable item entity.



placementRules = {
    {type = "closeTo", category = "foobar", amount = 4, distance = 50} 
    -- can only be placed within 50 units of 4 `foobar` entity category

    {type = "awayFrom", category = "blah", amount = 1, distance = 20}
    -- can only be placed 20 units away from a `blah` entity category
}


-- (This component should belong to the buildable entity.)
placementCategories = {
    "foobar", "grass" -- this entity belongs to foobar category and grass category.
}


]]


local placementCategories = require("placement_categories")




local function checkRule(rule)
    
end


local function checkRules(rules)
    assert(type(rules) == "table", "placementRules must be a table")
    for _, rule in ipairs(rules)do
        checkRule(rule)
    end
end

local function canUseItem(item, holder, build_x, build_y)
    if holder.x and holder.y and item.placeDistance then
        local d = math.distance(build_x-holder.x, build_y-holder.y)
        if d > item.placeDistance then
            return false
        end
    end

    if item.placementRules then

    end

    return true
end


local function useItem(item, holder, build_x, build_y)

end



local function newPlaceable(options)
    assert(options.itemName)
    assert(options.spawn)

    if options.placementRules then
        checkRules(options.placementRules)
    end
    
    return {
        itemName = options.itemName;
        placementSpawnFunction = options.spawn;

        itemHoldType = "place";
        canUseItem = canUseItem;
        useItem = useItem
    }
end


