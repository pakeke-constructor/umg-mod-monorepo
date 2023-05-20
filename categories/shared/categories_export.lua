
local regularCategories = require("shared.categories")
local chunkedCategories = require("shared.chunk_categories")



local categories = {}




function categories.getSet(category)
    assert(category, "categories.getEntities(category) requires a valid category as first argument.")
    return regularCategories.categoryMap[category]
end

function categories.getChunk(category)
    assert(category, "categories.getEntities(category) requires a valid category as first argument.")
    return chunkedCategories.categoryToChunk[category]
end





local isCategoryTc = typecheck.assert("entity", "string")

function categories.isCategory(ent, category)
    --[[
        returns true if ent has category `category`
    ]]
    isCategoryTc(ent, category)
    if type(ent.category) == "string" then
        return ent.category == category
    elseif type(ent.category) == "table" then
        for _, cat in ipairs(ent.category) do
            if cat == category then
                return true
            end
        end
    end
    return false
end



local iterateTc = typecheck.assert("string")

function categories.iterator(category)
    iterateTc(category)
    return ipairs(regularCategories.categoryMap[category])
end



local EMPTY_ITERATOR = function() return nil end

local chunkedIteratorTc = typecheck.assert("string", "number", "number")

function categories.chunkedIterator(category, x, y)
    chunkedIteratorTc(category, x, y)
    local chunk = chunkedCategories.categoryToChunk[category]
    if chunk then
        return chunk:iterator(x, y)
    end
    return EMPTY_ITERATOR
end



function categories.changeEntityCategory(ent, newCategory)
    --[[
        changes an entities category/s.
        This MUST be called instead of doing `ent.category = X`
        If an entity's category is changed manually it will cause stuff to break.
    ]]
    if not umg.exists(ent) then
        error("Entity doesn't exist!\n(If you just created this entity, then you must wait a frame. Entities are buffered and spawned inbetween frames.)")
    end

    regularCategories.removeEntity(ent)
    chunkedCategories.removeEntity(ent)

    ent.category = newCategory

    regularCategories.addEntity(ent)
    chunkedCategories.addEntity(ent)
end



umg.expose("categories", categories)


