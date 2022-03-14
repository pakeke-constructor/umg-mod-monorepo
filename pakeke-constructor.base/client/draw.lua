
--[[

Main drawing system.
Will emit draw calls based on position, and in correct order.

]]

local cameraLib = require("_libs.camera") -- HUMP Camera for love2d.

local constants = require("other.constants")


local drawGroup = group("image", "x", "y")


local floor = math.floor




local depthIndexer_max_depth = 0
local depthIndexer_min_depth = 0


local min = math.min
local max = math.max


-- Ordered drawing data structure
local depthIndexer = setmetatable({},
    --[[
        each pixel depth is represented by a set in depthIndexer.
        So, if zdep = floor(ent.y + ent.z or 0),
        depthIndexer[zdep] will get the set that holds ent.
    ]]
    {__index = function(t, zindx)
        t[zindx] = set()
        depthIndexer_max_depth = max(depthIndexer_max_depth, zindx)
        depthIndexer_min_depth = min(depthIndexer_min_depth, zindx)
        return t[zindx]
    end}
)



-- This table holds Entities that point to `y+z` values that ensure that
-- Entities in depthIndexer can always be found.  (y+z positions are updated only when system is ready.)
local positions = {}



local function addEnt(ent)
    -- Adds entity to depthIndexer
    local zindx = floor((ent.y + (ent.z or 0))/2)
    depthIndexer[zindx]:add(ent)
end

local function removeEnt(ent)
    -- Removes entity from previous depthIndexer location.
    local gett = positions[ent]
    depthIndexer[gett]:remove(ent)
    return gett
end

local function setEnt(ent)
    -- Sets current position of entity in depthIndexer, to give system awareness
    -- of what location ent is currently in in depthIndexer sets.
    positions[ent] = floor((ent.y + (ent.z or 0))/2)
end



drawGroup:on_added(function( ent )
    -- Callback for entity addition
    setEnt(ent)
    addEnt(ent)
end)



drawGroup:on_removed(function( ent )
    -- Callback for entity removal
    removeEnt(ent)
    positions[ent] = nil
end)




local rawget = rawget
local ipairs = ipairs
local setColor = graphics.setColor

local DEFAULT_ZOOM = constants.DEFAULT_ZOOM

local camera = cameraLib(0, 0, nil, nil, DEFAULT_ZOOM, 0)

graphics.camera = camera -- First monkeypatch!


local SCREEN_LEIGHWAY = constants.SCREEN_LEIGHWAY -- leighway of 400 pixels


local function isOnScreen(ent, w, h)
    --[[
        `ent` the entity to be checked if on screen
        `camera` the camera object, (graphics.camera)
        
        OPTIONAL:
        `w` and `h` are the width and height of the screen. 
            If these aren't supplied, they will be automatically given.
            It's slightly faster if they are supplied though.

        SCREEN_LEIGHWAY is just a constant that determines how many pixels
        of "leighway" we can give each object before it's counted as offscreen
    ]]
    w, h = w or graphics.getWidth(), h or graphics.getHeight()
    local x, y = camera:toCameraCoords(ent.x, ent.y, 0,0, w, h)

    return -SCREEN_LEIGHWAY <= x and x <= w + SCREEN_LEIGHWAY
            and -SCREEN_LEIGHWAY <= y and y <= h + SCREEN_LEIGHWAY
end

graphics.isOnScreen = isOnScreen -- Second monkeypatch!



local function mainDraw()
    local w, h = graphics.getWidth(), graphics.getHeight()
    for z_dep = depthIndexer_min_depth, depthIndexer_max_depth do
        if rawget(depthIndexer, z_dep) then
            local entSet = depthIndexer[z_dep]
            for _, ent in ipairs(entSet.objects) do
                if isOnScreen(ent, w, h) then
                    setColor(1,1,1)
                    if ent.image then
                        if ent.color then
                            setColor(ent.color)
                        end
                        call("drawEntity", ent)
                    end
                end
            end
        end
        call("drawIndex", z_dep)
    end

    graphics.atlas:flush()
end


on("resize", function(w, h)
    camera.w = w
    camera.h = h
end)


local scaleUI = constants.DEFAULT_UI_SCALE
function graphics.setUIScale(scale)
    assert(type(scale) == "number", "graphics.setUIScale(scale) requires a number")
    scaleUI = scale
end

function graphics.getUIScale()
    return scaleUI
end


on("draw", function()
    camera:draw()
    camera:attach()
    call("preDraw")
    call("mainDraw")
    call("postDraw")    
    camera:detach()

    graphics.scale(scaleUI)
    call("preDrawUI")
    call("mainDrawUI")
    call("postDrawUI")
end)


on("mainDraw", mainDraw)










local moveDrawGroup = group("x", "y", "image", "vy")
-- WELP! this sucks. 
-- If an entity has a z velocity component, and no y component,
-- it won't be changed in the Index structure...  Too bad lol!



local function fshift(ent)
    --[[
        shifts the entities around in the depthIndexer structure
        in a fast manner
    ]]
    local z_index = floor((ent.y + (ent.z or 0))/2)
    if positions[ent] ~= z_index then
        removeEnt(ent)
        setEnt(ent)
        addEnt(ent)
    end
end



on("update", function(_)    
    camera:update()
    for _, ent in ipairs(moveDrawGroup) do
        fshift(ent)
    end
end)


