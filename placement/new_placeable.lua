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

local constants = require("constants")


local function checkRuleValidity(rule)
    
end


local function assertRulesAreValid(rules)
    assert(type(rules) == "table", "placementRules must be a table")
    for _, rule in ipairs(rules)do
        checkRuleValidity(rule)
    end
end



local function closeTo(rule, item, holder, bx, by)
    local c = rule.category
    if not rawget(placementCategories, c) then
        return false -- none, deny
    end
    local count = 0
    for ent in placementCategories[c] do
        -- TODO: Should we check z axis here?
        if math.distance(ent.x-bx, ent.y-by) < rule.distance then
            count = count + 1
            if (rule.amount or 1) <= count then
                return true
            end
        end
    end
    return false
end


local function awayFrom(rule, item, holder, bx, by)
    local c = rule.category
    if not rawget(placementCategories, c) then
        return true -- none, we are fine lol
    end
    for ent in placementCategories[c] do
        -- TODO: Should we check z axis here?
        if math.distance(ent.x-bx, ent.y-by) < rule.distance then
            return false
        end
    end
    return true
end



local ruleChecks = {
    closeTo = closeTo;
    awayFrom = awayFrom
}



local function checkRule(rule, item, holder, build_x, build_y)
    local ruleType = rule.type
    assert(ruleChecks[ruleType], "Invalid placement ruletype for entity " .. item:type() .. ": rule " .. tostring(ruleType))
    return ruleChecks[ruleType](rule, item, holder, build_x, build_y)
end


local function canUseItem(item, holder, build_x, build_y)
    if holder.x and holder.y and item.placeDistance then
        local d = math.distance(build_x-holder.x, build_y-holder.y)
        if d > item.placeDistance then
            return false
        end
    end

    if item.placementRules then
        for _, rule in ipairs(item.placementRules) do
            if not checkRule(rule, item, holder, build_x, build_y) then
                return false
            end
        end
    end

    return true
end


local function useItem(item, holder, build_x, build_y)
    item.placementSpawnFunction(build_x, build_y)
end



local function newPlaceable(options)
    assert(options.itemName)
    assert(options.spawn)
    assert(not options.canUseItem, "canUseItem is automatically generated for placeable items!")
    assert(not options.useItem, "useItem is automatically generated for placeable items!")
    assert((not options.itemHoldType) or options.itemHoldType == "place", "placeable items must have `place` as itemHoldType!")

    local spawnFunc = options.spawn
    options.spawn = nil

    local entity = {
        placementSpawnFunction = spawnFunc;

        itemHoldType = "place";
        canUseItem = canUseItem;
        useItem = useItem
    }    
    
    for component, value in pairs(options) do
        entity[component] = value
    end

    if options.placementRules then
        assertRulesAreValid(options.placementRules)
    end

    return entity
end




return newPlaceable
