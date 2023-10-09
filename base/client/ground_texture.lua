

local defaultGround



local groundTexture = {}



local WHITE = objects.Color.WHITE



local function parseGroundObject(obj)
    --[[
        returns: {
            tileWidth = X,
            tileHeight = X,
            images = { "tile1", "tile2", ... }
        }
    ]]
    local images = obj.images
    local buffer = objects.Array()
    for _,tilename in ipairs(images) do
        if not (client.assets.images[tilename]) then
            error("unknown image: " .. tostring(tilename))
        end
        buffer:add(client.assets.images[tilename])
    end
    
    assert(buffer:size()>0, "need at least 1 tile")

    local tile1 = buffer[1]
    local _,_,width, height = tile1:getViewport()

    for _, tile in ipairs(buffer) do
        local _,_,w,h = tile:getViewport()
        assert(w==width and h==height, "All ground tiles must be the same size")
    end

    return {
        images = buffer,
        tileWidth = width,
        tileHeight = height,
        color = obj.color or WHITE
    }
end





local setGroundTc = typecheck.assert("dimension", "table")
local setDefaultGroundTc = typecheck.assert("table")


function groundTexture.setDefaultGround(obj)
    setDefaultGroundTc(obj)
    defaultGround = parseGroundObject(obj)
end


function groundTexture.setGround(dimension, obj)
    setGroundTc(dimension, obj)
    local overseerEnt = dimensions.getOverseer(dimension)
    overseerEnt.groundTexture = parseGroundObject(obj)
end



local LEIGHWAY = 10

local PRIME = 7


local function drawGround(obj)
    local images = obj.images
    local w,h = love.graphics.getDimensions()

    local camera = rendering.getCamera()
    local start_x, start_y = camera:toWorldCoords(0,0)
    local endx, endy = camera:toWorldCoords(w,h)

    start_x = start_x - LEIGHWAY
    start_y = start_y - LEIGHWAY
    endx, endy = endx+LEIGHWAY, endy+LEIGHWAY

    local tw,th = math.max(obj.tileWidth-1,1), math.max(obj.tileHeight-1,1)
    
    local dx = camera.x % tw
    local dy = camera.y % th

    -- add tw*4 and th*4 onto the ground so quads don't "leak"
    for x = start_x - dx, endx+tw*4, tw do
        for y = start_y - dy, endy+th*4, th do
            local normx, normy = math.floor(x/tw), math.floor(y/th) 
            local index = ((PRIME*normx+normy) % images:size()) + 1
            local tile = images[index]
            local drawx = math.floor(normx * tw)
            local drawy = math.floor(normy * th)
            rendering.drawImage(tile, drawx, drawy)
        end
    end
end


umg.on("rendering:drawGround", function(camera)
    local dimension = camera:getDimension()
    local overseerEnt = dimensions.getOverseer(dimension)

    local obj = overseerEnt.groundTexture or defaultGround

    if obj then
        love.graphics.push("all")
        love.graphics.setColor(obj.color)

        drawGround(obj)

        love.graphics.pop()
    end
end)





return groundTexture

