
local getQuadOffset = require("client.image_helpers.quad_offsets")
local images = client.assets.images


local function drawImage(quadName, x, y, rot, sx, sy, ox, oy, kx, ky)
    local quad = images[quadName]
    if not quad then
        error(("Unknown quadName: %s\nMake sure you put all images in the assets folder and name them!"):format(tostring(quadName)))
    end    
    local oxx, oyy = getQuadOffset(quad)
    
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

