


local placementCategories = setmetatable({}, {
    __index = function(t,k)
        t[k] = base.Set()
        return t[k]
    end
})


local placeEntities = group("x", "y", "placementCategory")




placeEntities:onAdded(function(ent)
    local category = ent.placementCategory
    assert(category, "entity was not given a placementCategory: " .. tostring(ent))
    -- if ent.placementCategory is not constant, there will be issues.
    if type(category) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(category) do
            placementCategories[c]:add(ent)
        end
    else
        assert(type(category) == "string", ".placementCategory value must be string or list of strings: " .. tostring(ent))
        placementCategories[category]:add(ent)
    end
end)


placeEntities:onRemoved(function(ent)
    local category = ent.placementCategory
    if type(category) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(category) do
            placementCategories[c]:add(ent)
        end
    else
        placementCategories[category]:add(ent)
    end
end)


return placementCategories

