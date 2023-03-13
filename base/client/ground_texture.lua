

local Array = require("shared.array")
local camera = require("client.camera")
local drawImage = require("client.image_helpers.draw_image")
local typecheck = require("shared.typecheck")




local groundTileWidth, groundTileHeight
local groundTiles;


local groundTexture = {}


local color = {1,1,1}



local tcSetColor = typecheck.assert("number", "number", "number")

function groundTexture.setColor(color_or_r, g,b)
    if type(color_or_r) == "table" then
        color = color_or_r
    else
        local r = color_or_r
        tcSetColor(r,g,b)
        color = {r,g,b}
    end
end



function groundTexture.setTextureList(arr)
    local buffer = Array()
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

        local start_x, start_y = camera:toWorldCoords(0,0)
        local endx, endy = camera:toWorldCoords(w,h)

        start_x = start_x - LEIGHWAY
        start_y = start_y - LEIGHWAY
        endx, endy = endx+LEIGHWAY, endy+LEIGHWAY

        local tw,th = groundTileWidth-1, groundTileHeight-1
        
        local dx = camera.x % tw
        local dy = camera.y % th

        for x = start_x - dx, endx+tw, tw do
            for y = start_y - dy, endy+th, th do
                local normx, normy = math.floor(x/tw), math.floor(y/th) 
                local index = ((PRIME*normx+normy) % groundTiles:size()) + 1
                local tile = groundTiles[index]
                local drawx = math.floor(normx * tw)
                local drawy = math.floor(normy * th)
                drawImage(tile, drawx, drawy)
            end
        end
    end
    love.graphics.pop()
end)





return groundTexture

