

local abs = math.abs

local DEFAULT_SIZE = 10


local function isHovered(ent)
    local mx, my = rendering.getMousePositionInWorld()
    
    local dx, dy = abs(ent.x - mx), abs(ent.y - my)

    if ent.image then
        -- check image dimensions
        local ox,oy = rendering.getQuadOffsets(ent.image)
        local sc = ent.scale or 1
        local sx, sy = (ent.scaleX or 1) * sc, (ent.scaleY or 1) * sc

        if dx <= ox*sx and dy <= oy*sy then
            return true
        end
    else
        -- check entity size directly.
        return math.distance(ent.x - mx, ent.y - my) < (ent.size or DEFAULT_SIZE)
    end
end



return isHovered

