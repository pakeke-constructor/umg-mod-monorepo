
local categoryMap = require("shared.categories")

local categories = {}




function categories.getSet(category)
    assert(category, "categories.getEntities(category) requires a valid category as first argument.")
    return categoryMap[category]
end



function categories.ipairs(category)
    return categoryMap[category]:iter()
end

function categories.iter(category)
    return categoryMap[category]:iter()
end





function categories.changeEntityCategory(ent, newCategory)
    --[[
        changes an entities category/s.
        This MUST be called instead of doing `ent.category = X`
        If an entity's category is changed manually it will cause stuff to break.
    ]]
    if not umg.exists(ent) then
        error("Entity doesn't exist!\n(If you just created this entity, then you must wait a frame. Entities are buffered and spawned inbetween frames..)")
    end

    if ent.category then
        if type(ent.category) == "table" then
            -- its a list of categories:
            for i=1, #ent.category do
                local c = ent.category[i]
                if rawget(categoryMap, c) then
                    categoryMap[c]:remove(ent)
                end
            end
        else -- its just a category string:
            local c = ent.category
            if rawget(categoryMap, c) then
                categoryMap[c]:remove(ent)
            end
        end
    end

    assert(newCategory, "entity was not given a category value: " .. tostring(ent))
    -- if ent.category is not constant, there will be issues.
    if type(newCategory) == "table" then
        -- this entity has multiple categories.
        for _, c in ipairs(newCategory) do
            categoryMap[c]:add(ent)
        end
    else
        if type(newCategory) ~= "string" then 
            error("newCategory value must be string or list of strings: " .. tostring(ent))
        end
        categoryMap[newCategory]:add(ent)
    end
    ent.category = newCategory
end


umg.expose("categories", categories)


