


local placementCategories = setmetatable({}, {
    __index = function(t,k)
        t[k] = objects.Set()
        return t[k]
    end
})


--[[
    entities that determine how other entities can be placed;
    (e.g. to ensure objects can't be placed overlapping each other)
]]
local placementGroup = umg.group("x", "y", "placementCategory")




placementGroup:onAdded(function(ent)
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


placementGroup:onRemoved(function(ent)
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

