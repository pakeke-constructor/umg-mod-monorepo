
local abs = math.abs


local function isHovered(ent)
    --[[
        returns true if the entity is being hovered by the mouse.
        False otherwise.
    ]]
    local mx, my = rendering.getWorldMousePosition()
    
    local dx, dy = abs(ent.x - mx), abs(ent.y - my)
    local w,h = rendering.getEntityDisplaySize(ent)

    return (dx <= w/2) and (dy <= h/2)
end


return isHovered

