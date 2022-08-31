
local getQuadOffsets = require("client.image_helpers.quad_offsets")

local abs = math.abs

local DEFAULT_SIZE = 10


local function isHovered(ent)
    local mx, my = base.camera:getMousePosition()
    
    local dx, dy = abs(ent.x - mx), abs(ent.y - my)

    if ent.image then
        local ox,oy = getQuadOffsets(ent.image)
        if dx <= ox and dy <= oy then
            return true
        end
    else
        return math.distance(ent.x - mx, ent.y - my) < (ent.size or DEFAULT_SIZE)
    end
end



return isHovered

