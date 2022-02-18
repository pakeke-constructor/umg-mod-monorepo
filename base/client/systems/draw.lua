
--[[

Main drawing system.
Will emit draw calls based on position, and in correct order.

]]

local cameraLib = require("_libs.camera") -- HUMP Camera for love2d.


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
    local zindx = floor((ent.y + ent.z or 0)/2)
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
    positions[ent] = floor((ent.y + ent.z or 0)/2)
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
    ent.draw = nil
end)







local rawget = rawget
local ipairs = ipairs

local setColor = graphics.setColor

local DEFAULT_ZOOM = 4

local camera = cameraLib(0, 0, DEFAULT_ZOOM, 0)

graphics.camera = camera -- First monkeypatch!



local drawShockWaves


local SCREEN_LEIGHWAY = 400 -- leighway of 400 pixels


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
    local x, y = camera:cameraCoords(ent.x, ent.y, 0,0, w, h)

    return -SCREEN_LEIGHWAY <= x and x <= w + SCREEN_LEIGHWAY
            and -SCREEN_LEIGHWAY <= y and y <= h + SCREEN_LEIGHWAY
end



local function mainDraw()
    local w, h = graphics.getWidth(), graphics.getHeight()

    for z_dep = depthIndexer_min_depth, depthIndexer_max_depth do
        if rawget(depthIndexer, z_dep) then
            local entSet = depthIndexer[z_dep]
            for _, ent in ipairs(entSet.objects) do
                if isOnScreen(ent, w, h) then
                    setColor(1,1,1)
                    if not ent.hidden then
                        if ent.colour then
                            setColor(ent.colour)
                        end
                        call("drawEntity", ent)
                    end
                end
            end
        end
        call("drawIndex", z_dep)
    end

    graphics.atlas:flush()

    drawShockWaves()
end





on("draw", function()
    call("preDraw")
    call("mainDraw")
    call("postDraw")
end)


on("mainDraw", mainDraw)






local newShockWave = require("src.misc.unique.shockwave")

-- a Set for all shockwave objects that are being drawn
local shockwaveSet = set()



on("update", function(dt)
    for _,sw in ipairs(shockwaveSet.objects)do
        sw:update(dt)
        if sw.isFinished then
            shockwaveSet:remove(sw)
            sw.colour = nil -- easier on GC
        end
    end
end)



local function shockwave(x, y, start_size, end_size, thickness, time, colour)
    local sw = newShockWave(x,y,start_size, end_size, thickness, time, colour or {1,1,1,1})
    shockwaveSet:add(sw)
end


function drawShockWaves()
    for _,sw in ipairs(shockwaveSet.objects) do
        sw:draw()
    end
end










local moveDrawGroup = group("x", "y", "draw", "vely")
-- WELP! this sucks. 
-- If an entity has a z velocity component, and no y component,
-- it won't be changed in the Index structure...  Too bad lol!



local function fshift(ent)
    --[[
        shifts the entities around in the depthIndexer structure
        in a fast manner
    ]]
    local z_index = floor((ent.y + ent.z or 0)/2)
    if positions[ent] ~= z_index then
        removeEnt(ent)
        setEnt(ent)
        addEnt(ent)
    end
end



on("update", function(_)    
    for _, ent in ipairs(moveDrawGroup) do
        fshift(ent)
    end
end)


