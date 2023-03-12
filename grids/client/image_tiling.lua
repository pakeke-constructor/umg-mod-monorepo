

local grids = require("shared.grids")


local tileGroup = umg.group("imageTiling", "x", "y")




local function matches(layout, bufKey)
    for y=1, 3 do
        for x = 1, 3 do
            if (y ~= 2) or (x ~= 2) then
                local tileExists = bufKey[y][x]
                local char = layout[y][x]
                if char == "#" and (not tileExists) then
                    return false
                elseif char == "." and tileExists then
                    return false
                end
            end
        end
    end
    return true
end







local function randomChoice(arr)
    return arr[math.random(1, #arr)]
end



local function updateTile(ent)
    local imageTiling = ent.imageTiling
    local grid = grids.getGrid(ent)
    local gridX,gridY = grid:getPosition(ent.x+0.1, ent.y+0.1)
    assert(grid:get(gridX, gridY) == ent, "excuse me?")
    
    local bufKey = {}
    for dy=-1,1 do
        local ybuf = {}
        for dx=-1,1 do
            local e = grid:get(gridX+dx, gridY+dy)
            if e then
                table.insert(ybuf, true)
            else
                table.insert(ybuf, false)
            end
        end
        table.insert(bufKey, ybuf)
    end

    for _, tiling in ipairs(imageTiling) do
        local image = (tiling.images and randomChoice(tiling.images)) or tiling.image
        for _, layout in ipairs(tiling.allLayouts) do
            if matches(layout, bufKey) then
                ent.image = image
                ent.scaleX = layout.scaleX or 1
                ent.scaleY = layout.scaleY or 1
                ent.rot = layout.rot or 0
                return
            end
        end
    end

    -- no image found.. I guess we just leave it?
end




local function assertDimensionsSame(imageStr, width, height)
    local quad = client.assets.images[imageStr]
    if not quad then
        error("unknown image: " .. tostring(imageStr))
    end
    local _,_,w,h = quad:getViewport()

    if not width then
        return w,h
    end

    assert(w == width and h == height, "tile component: image dimensions must all be the same")
    return width,height
end


local VALID_CHARS = {
    ["?"]=true, ["#"]=true, ["."]=true, ["X"]=true
}


local function assertFor(bool, entType)
    if not bool then
        error("imageTiling component invalid for entity: " .. entType)
    end
end


local function assertLayout(layout, entType)
    assert(type(layout) == "table" and #layout == 3, "imageTiling layout invalid")
    for _, v in ipairs(layout) do
        assert(type(v) == "table" and #v == 3, "imageTiling layout invalid")
        for i=1, #v do
            local ch = v[i]
            assertFor(VALID_CHARS[ch], entType)
        end
    end
end


local function assertComponent(imageTiling, entType)
    local w,h
    for _, tiling in ipairs(imageTiling) do
        assertLayout(tiling.layout, entType)
        assertFor(tiling.image, entType)
        w,h = assertDimensionsSame(tiling.image, w, h)        
    end
end







local function layoutEquals(layout1, layout2)
    for i=1, #layout1 do
        if layout1[i] ~= layout2[i] then
            return false
        end
    end
    return true
end

local function tryAddLayout(allLayouts, layout)
    for _, layout2 in ipairs(allLayouts) do
        if layoutEquals(layout, layout2) then
            return
        end
    end
    table.insert(allLayouts, layout)
end



local function reverse(t)
    local ret = {}
    for i=#t, 1, -1 do
        table.insert(ret, t[i])
    end
    return ret
end


local function addFlips(tiling)
    if tiling.canFlipHorizontal then
        local newLayout = table.copy(tiling.layout)
        newLayout[1] = reverse(newLayout[1])
        newLayout[2] = reverse(newLayout[2])
        newLayout[3] = reverse(newLayout[3])
        newLayout.scaleX = -1
        tryAddLayout(tiling.allLayouts, newLayout)
    end

    if tiling.canFlipVertical then
        local newLayout = table.copy(tiling.layout)
        newLayout[1], newLayout[3] = newLayout[3], newLayout[1]
        newLayout.scaleY = -1
        tryAddLayout(tiling.allLayouts, newLayout)
    end
end



local function addRotations(tiling)
    if not tiling.canRotate then
        return
    end
    --[[
        rotates a tiling layout 4 times, 90 degree rotations
    ]]
    local l = tiling.layout
    for i=1,3 do
        -- rotate clockwise
        local layout = {
            --  l[y][x]
            {l[3][1],l[2][1],l[1][1]},
            {l[3][2],l[2][2],l[1][2]},
            {l[3][3],l[2][3],l[1][3]},
            rot = i * (math.pi/2)
        }
        l = layout
        tryAddLayout(tiling.allLayouts, layout)
    end
end




local MANGLED = {} -- unique identifier table
-- ensures we don't mangle twice


local sortKey = function(a,b)
    return (a.priority or 0) > (b.priority or 0)
end


local function mangleComponent(ent)
    local imageTiling = ent.imageTiling
    if imageTiling[MANGLED] then
        return  -- already mangled
    end
    
    table.sort(imageTiling, sortKey)

    assertComponent(imageTiling, ent:type())
    for _, tiling in ipairs(imageTiling) do
        tiling.allLayouts = {tiling.layout}
        addFlips(tiling)
        addRotations(tiling)
    end

    imageTiling[MANGLED] = true
end




local function updateSurroundingTiles(ent)
    local grid = grids.getGrid(ent)
    local gridX,gridY = grid:getPosition(ent)
    
    for dy=-1,1 do
        for dx=-1,1 do
            if (dx ~= 0) or (dy ~= 0) then
                local e = grid:get(gridX+dx, gridY+dy)
                if umg.exists(e) then
                    updateTile(e)
                end
            end
        end
    end
end





--[[
    yikes.. this code is a bit fragile.
    This assumes that the grid onRemoved()/onAdded() is called 
    before these callbacks. 
    It should be fine, because file load order is deterministic...
    but still! yikes!!
]]

tileGroup:onAdded(function(ent)
    assert(ent:isShared("imageTiling"), "imageTiling component must be shared")
    mangleComponent(ent)
    updateTile(ent)
    updateSurroundingTiles(ent)
end)



tileGroup:onRemoved(function(ent)
    updateSurroundingTiles(ent)
end)



