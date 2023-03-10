

local categoryMap = setmetatable({}, {
    __index = function(t,k)
        t[k] = base.Set()
        return t[k]
    end
})


local categoryEntities = umg.group("x", "y", "category")


categoryEntities:onAdded(function(ent)
    local category = ent.category
    if not category then 
        return -- assume that this entity doesn't have a category yet.
    end

    -- if ent.category is not constant, there will be issues.
    if type(category) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(category) do
            categoryMap[c]:add(ent)
        end
    else
        assert(type(category) == "string", ".category value must be string or list of strings: " .. tostring(ent))
        categoryMap[category]:add(ent)
    end
end)


categoryEntities:onRemoved(function(ent)
    local category = ent.category
    if not category then
        return -- nothing much we can do here!
    end
    if type(category) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(category) do
            categoryMap[c]:remove(ent)
        end
    else
        categoryMap[category]:remove(ent)
    end
end)



return categoryMap

