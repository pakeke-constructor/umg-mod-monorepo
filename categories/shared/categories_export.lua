
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




local iterateTc = base.typecheck.assert("string")

function categories.iterate(category)
    iterateTc(category)
    return regularCategories.categoryMap[category]:ipairs()
end



local iterateChunkedTc = base.typecheck.assert("string", "number", "number")

function categories.iterateChunked(category, x, y)
    iterateChunkedTc(category, x, y)
    local chunk = chunkedCategories.categoryToChunk[category]
    if chunk then
        return chunk:iterate(x, y)
    end
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


