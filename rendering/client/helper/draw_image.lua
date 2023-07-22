
local imageOffsets = require("client.helper.image_offsets")
local getImageOffsets = imageOffsets.getImageOffsets

local images = client.assets.images



local function drawImage(quadName_or_quad, x, y, rot, sx, sy, ox, oy, kx, ky)
    local quad = images[quadName_or_quad] or quadName_or_quad
    if not (quad and type(quad) == "userdata") then
        error(("Unknown quadName: %s\nMake sure you put all images in the assets folder and name them!"):format(tostring(quadName_or_quad)))
    end    
    local oxx, oyy = getImageOffsets(quad)
    
    client.atlas:draw(
        quad, 
        x, y, rot or 0, 
        sx or 1, sy or 1,
        oxx + (ox or 0), 
        oyy + (oy or 0), 
        kx, ky
    )
end

return drawImage

