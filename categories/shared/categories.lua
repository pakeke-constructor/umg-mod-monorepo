

local categoryMap = setmetatable({}, {
    __index = function(t,k)
        t[k] = base.Set()
        return t[k]
    end
})


local categoryGroup = umg.group("x", "y", "category")



local function getAllCategories(ent)
    --[[
        Entities can store categories in two different ways:

        ent.category = "category1"
        ent.category = {"category1", "category2", "categoryABC"}
    ]]
    local category = ent.category
    local returnArray
    if type(category) == "table" then
        returnArray = category
    elseif type(category) == "string" then
        returnArray = {category}
    else
        error("Bad category component for entity " .. ent:type())
    end
    for _, c in ipairs(returnArray) do
        assert(type(c) == "string", "Bad category component for entity " .. ent:type())
    end
end



categoryGroup:onAdded(function(ent)
    if not ent.category then 
        return -- assume that this entity doesn't have a category yet.
    end

    local allCategories = getAllCategories(ent)
    for _, category in ipairs(allCategories) do
        categoryMap[category]:add(ent)
        assert(type(category) == "string", ".category value must be string or list of strings: " .. tostring(ent))
    end
end)



categoryGroup:onRemoved(function(ent)
    if not ent.category then
        return -- nothing much we can do here!
    end

    local allCategories = getAllCategories(ent)
    for _, category in ipairs(allCategories) do
        categoryMap[category]:remove(ent)
    end
end)



return categoryMap

