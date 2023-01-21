
local getQuadOffsets = require("client.image_helpers.quad_offsets")


local clickEnts = umg.group("x", "y", "onClick")



local DEFAULT_SIZE = 10 --  this seems reasonable as a default...? maybe




local abs = math.abs

local function isInRange(ent, worldX, worldY, dist)
    local dx, dy = abs(ent.x - worldX), abs(ent.y - worldY)
    
    if ent.image then
        local ox,oy = getQuadOffsets(ent.image)
        if dx <= ox and dy <= oy then
            return true
        end
    else
        local size = ent.size or DEFAULT_SIZE
        if dist <= size then
            return true
        end
    end
end





umg.on("gameMousepressed", function(mx, my, button, istouch, presses)
    -- TODO: This is kinda trash.
    -- this needs to be spatial partitioned probably.

    local worldX, worldY = base.camera:toWorldCoords(mx, my)

    local bestDist = math.huge
    local bestEnt = nil

    for _, ent in ipairs(clickEnts) do
        local x, y = ent.x, base.getDrawY(ent.y, ent.z)
        local dist = math.distance(x-worldX, y-worldY)
        if dist < bestDist then
            if isInRange(ent, worldX, worldY, dist) then
                bestEnt = ent
                bestDist = dist
            end
        end
    end

    if bestEnt then
        client.send("clickEntity", bestEnt, button, worldX, worldY)
    end
end)




client.on("clickEntity", function(ent, username, button, worldX, worldY)
    ent:onClick(username, button, worldX, worldY)
end)




