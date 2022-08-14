
local categories = require("categories")

local exp = {}




function exp.getSet(category)
    assert(category, "categories.getEntities(category) requires a valid category as first argument.")
    return categories[category]
end





function exp.changeEntity(ent, newCategory)
    --[[
        changes an entities category/s.
        This MUST be called instead of doing `ent.category = X`
        If an entity's category is changed manually it will cause stuff to break.
    ]]

    assert(exists(ent), "Entity doesn't exist!")
    if type(ent.category) == "table" then
        -- its a list of categories:
        for i=1, #ent.category do
            local c = ent.category[i]
            if rawget(categories, c) then
                categories[c]:remove(ent)
            end
        end
    else -- its just a category string:
        local c = ent.category
        if rawget(categories, c) then
            categories[c]:remove(ent)
        end
    end

    assert(newCategory, "entity was not given a category value: " .. tostring(ent))
    -- if ent.category is not constant, there will be issues.
    if type(newCategory) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(newCategory) do
            categories[c]:add(ent)
        end
    else
        if type(newCategory) ~= "string" then 
            error("newCategory value must be string or list of strings: " .. tostring(ent))
        end
        categories[newCategory]:add(ent)
    end
end


export("categories", export)

require("category_proximity")

