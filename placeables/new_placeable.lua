--[[

creates a new buildable item entity.



placementRules = {
    {type = "near", category = ""}
}


]]


local placementCategories = require("placement_categories")


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
    assert(options.buildItem)
    
    return {
        itemName = options.itemName;

        itemHoldType = "place";
        canUseItem = canUseItem;
        useItem = useItem
    }
end


