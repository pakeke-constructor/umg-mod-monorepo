local EMPTY_LIST = {}

local function getAllCategories(ent)
    --[[
        Entities can store categories in two different ways:

        ent.category = "category1"
        ent.category = {"category1", "category2", "categoryABC"}
    ]]
    local category = ent.category
    if not ent.category then
        return EMPTY_LIST -- this ent hasn't been assigned a category yet?
    end

    if type(category) == "table" then
        return category
    elseif type(category) == "string" then
        return {category}
    else
        error("Bad category component for entity " .. ent:type())
    end
end


return getAllCategories
