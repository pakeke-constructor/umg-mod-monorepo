



local controllableGroup = umg.group("controllable", "controller", "x", "y")

local max, min = math.max, math.min


local function clampToWithinBorder(border, x,y)
    x = min(max(border.x, x), border.x + border.width)
    y = min(max(border.y, y), border.y + border.height)
    return x, y
end




umg.on("state:gameUpdate", function(dt)
    --[[
        we restrict controllable entities to the border,
        just so it's more responsive on client-side.
    ]]
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
            local overseerEnt = dimensions.getOverseer(ent.dimension)
            if overseerEnt and overseerEnt.border then
                local border = overseerEnt.border
                ent.x, ent.y = clampToWithinBorder(border, ent.x, ent.y)
            end
        end
    end
end)

