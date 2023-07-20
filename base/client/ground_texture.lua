


local groundTileWidth, groundTileHeight
local groundTiles;


local groundTexture = {}


local color = {1,1,1}




function groundTexture.setColor(newcolor)
    if type(newcolor) ~= "table" then
        error("Bad argument to groundTexture.setColor, expects a color as an argument", 2)
    end
    color = newcolor;
end



function groundTexture.setTextureList(arr)
    local buffer = objects.Array()
    for _,tilename in ipairs(arr) do
        if not (client.assets.images[tilename]) then
            error("unknown image: " .. tostring(tilename))
        end
        buffer:add(client.assets.images[tilename])
    end
    
    groundTiles = buffer
    assert(buffer:size()>0, "need at least 1 tile")

    local tile1 = buffer[1]
    local _
    _,_,groundTileWidth, groundTileHeight = tile1:getViewport()

    for _, tile in ipairs(buffer) do
        local _,_,w,h = tile:getViewport()
        assert(w==groundTileWidth and h==groundTileHeight, "All ground tiles must be the same size")
    end
end



local LEIGHWAY = 10

local PRIME = 7


umg.on("drawGround", function()
    love.graphics.push("all")
    love.graphics.setColor(color)
    if groundTiles then
        local w,h = love.graphics.getDimensions()

        local camera = rendering.getCamera()
        local start_x, start_y = camera:toWorldCoords(0,0)
        local endx, endy = camera:toWorldCoords(w,h)

        start_x = start_x - LEIGHWAY
        start_y = start_y - LEIGHWAY
        endx, endy = endx+LEIGHWAY, endy+LEIGHWAY

        local tw,th = groundTileWidth-1, groundTileHeight-1
        
        local dx = camera.x % tw
        local dy = camera.y % th

        -- add tw*4 and th*4 onto the ground so it doesn't "leak"
        for x = start_x - dx, endx+tw*4, tw do
            for y = start_y - dy, endy+th*4, th do
                local normx, normy = math.floor(x/tw), math.floor(y/th) 
                local index = ((PRIME*normx+normy) % groundTiles:size()) + 1
                local tile = groundTiles[index]
                local drawx = math.floor(normx * tw)
                local drawy = math.floor(normy * th)
                rendering.drawImage(tile, drawx, drawy)
            end
        end
    end
    love.graphics.pop()
end)





return groundTexture

