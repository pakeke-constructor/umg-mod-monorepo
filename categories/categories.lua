



local categories = setmetatable({}, {
    __index = function(t,k)
        t[k] = base.Set()
        return t[k]
    end
})


local categoryEntities = group("x", "y", "category")


categoryEntities:onAdded(function(ent)
    local category = ent.category
    assert(category, "entity was not given a category value: " .. tostring(ent))
    -- if ent.category is not constant, there will be issues.
    if type(category) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(category) do
            categories[c]:add(ent)
        end
    else
        assert(type(category) == "string", ".category value must be string or list of strings: " .. tostring(ent))
        categories[category]:add(ent)
    end
end)


categoryEntities:onRemoved(function(ent)
    local category = ent.category
    if type(category) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(category) do
            categories[c]:add(ent)
        end
    else
        categories[category]:add(ent)
    end
end)



return categories

