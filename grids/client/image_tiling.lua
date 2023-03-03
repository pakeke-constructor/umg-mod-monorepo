

local grid = require("shared.grid")

local tileGroup = umg.group("imageTiling", "x", "y")






local VALID_TILE_TYPES = {
    fill = true,
    
    topLeft = true,
    bottomLeft = true,
    topRight = true,
    bottomRight = true,

    left = true,
    right = true,
    bottom = true,
    top = true
}



local DIAGONAL_ROTATIONS = {
    topLeft = 0,
    topRight = -math.pi/2,
    bottomLeft = math.pi/2,
    bottomRight = math.pi
}

local DIRECTIONAL_ROTATIONS = {
    left = 0,
    right = math.pi,
    bottom = math.pi/2,
    top = -math.pi/2
}




local function assertDimensionsSame(imageStr, width, height)
    local quad = client.assets.images[imageStr]
    local _,_,w,h = quad:getViewport()

    if not width then
        assert(height,"ey?")
        return w,h
    end

    assert(w == width and h == height, "tile component: image dimensions must all be the same")
    return width,height
end


local function assertComponent(tile)
    local w, h 
    for tiletype, arr_or_string in pairs(tile) do
        if not VALID_TILE_TYPES[tiletype] then
            error("invalid tile type: " .. tostring(tiletype))
        end
        if type(arr_or_string) == "string" then
            w,h = assertDimensionsSame(arr_or_string, w, h)
        else
            assert(type(arr_or_string) == "table", "Must be a string or a table")
        end
    end
end





--[[
This function will take possible rotations of tiles,
and fill in the gaps when we have an undefined tile.

So for example if we have tiles: {`left`, `right`, `top`,} and no bottom,
the `bottom` tile will be filled via a 90 degree rotation of the left tile.
]]
local function fillTilePossibilities(imageTiling, rotationMap)
    local confirmedTileType
    for ttype, _ in pairs(rotationMap) do
        if imageTiling[ttype] then
            confirmedTileType = ttype
            break
        end
    end

    if not confirmedTileType then
        local buffer = base.Array()
        for tiletype,_ in pairs(rotationMap) do
            buffer:add(tiletype)
        end
        error("Missing a required tile type.\nNeed one or more of the following: " .. table.concat(buffer, " "))
    end

    for ttype, _ in pairs(rotationMap) do
        if not imageTiling[ttype] then
            -- then we gotta fill in this tile
            local drot = rotationMap[confirmedTileType] - rotationMap[ttype]
            imageTiling[ttype] = {
                image = imageTiling[confirmedTileType],
                rot = drot
            }
        else
            imageTiling[ttype] = {
                image = imageTiling[ttype],
                rot = nil
            }
        end
    end
end



local MANGLED = {} -- unique identifier table
-- ensures we don't mangle twice



local function mangleComponent(imageTiling)
    if imageTiling[MANGLED] then
        return  -- already completed
    end
    
    assertComponent(imageTiling)
    fillTilePossibilities(imageTiling, DIAGONAL_ROTATIONS)
    fillTilePossibilities(imageTiling, DIRECTIONAL_ROTATIONS)

    imageTiling[MANGLED] = true
end




local function randomChoice(arr)
    return arr[math.random(1, #arr)]
end



--[[


TODO: Refactor all of this
We are missing a terrain tile type.
(Concave corner tiles)


Also, we want our system to support fences!
Make it more robust:
Do some more planning.




]]



-- TODO: All this should be refactored
local TILE_REQUIREMENTS = {
    [{
        true, true, true,
        true,       true,
        true, true, true
    }] = "fill",
    [{
        true, true, true,
        true,       true,
       false,false,false
    }] = "bottom",
    [{
        false,false,false,
        true,       true,
        true, true, true
    }] = "top",
    [{
        false, true, true,
        false,       true,
        false, true, true
    }] = "left",
    [{
        true, true, false,
        true,       false,
        true, true, false
    }] = "right",
    [{
       false,false,false,
       false,       true,
       false, true, true
    }] = "topRight",
    [{
        false,true,true,
        false,       true,
        false,false,false
    }] = "bottomLeft",
    [{
        true, true,false,
        true,       false,
        false,false,false
    }] = "bottomRight",
    [{
        false,false,false,
        true,       false,
        true,true,false
    }] = "topLeft",
}

--[[

https://twitter.com/OskSta/status/1448248658865049605/photo/3
https://twitter.com/OskSta/status/1448248658865049605/photo/3
https://twitter.com/OskSta/status/1448248658865049605/photo/3
https://twitter.com/OskSta/status/1448248658865049605/photo/3
https://twitter.com/OskSta/status/1448248658865049605/photo/3
https://twitter.com/OskSta/status/1448248658865049605/photo/3

Take a look at this blog

]]


local function convertToBitKey(bufKey)
    --[[
        converts a buffer of booleans to bitwise integer
        eg:  {true, false, true} 
        -->   1 0 1
        -->   5
    ]]
    local n = 1
    local ret = 0
    for i, bool in ipairs(bufKey) do
        if bool then
            ret = ret + n
        end
        n = n * 2
    end
    return ret
end


local tileRequirementTypes = {}


for bufKey, tileType in pairs(TILE_REQUIREMENTS) do
    table.insert(tileRequirementTypes, {
        bitKey = convertToBitKey(bufKey),
        tileType = tileType
    })
end






local function selectImage(ent)
    local imageTiling = ent.imageTiling
    local x,y = ent.x, ent.y
    local grid = grids.getGrid(ent)
    local gridX,gridY = grid.getGridPosition(ent)
    
    local bufKey = {}
    for y=-1,1 do
        for dy=-1,1 do
            if (dx ~= 0) or (dy ~= 0) then
                local ent = grid:get(gridX + dx, gridY + dy)
                table.insert(bufKey, ent and true or false)
            end
        end
    end
    local bitKey = convertToBitKey(bufKey)

    for _, tileRequirement in ipairs(tileRequirementTypes) do
        if bitKey == bit.band(tileRequirement.bitKey
    end

    
    --[[ todo: select grid position from here and return image ]]
end



tileGroup:onAdded(function(ent)
    assert(ent:isShared("imageTiling"), "imageTiling component must be shared")
    mangleComponent(ent.imageTiling)
    local image = selectImage(ent)
    ent.image = image
end)



tileGroup:onRemoved(function(ent)
    for _, 
end)



