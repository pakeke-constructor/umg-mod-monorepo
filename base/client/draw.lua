
--[[

Main drawing system.
Will emit draw calls based on position, and in correct order.

]]

local cameraLib = require("_libs.camera") -- HUMP Camera for love2d.

local constants = require("other.constants")
local Set = require("other.set")


local drawGroup = group("image", "x", "y")


local floor = math.floor




-- Ordered drawing data structures:
local sortedFrozenEnts = {} -- for ents that dont move

local sortedMoveEnts = {} -- for ents that move







drawGroup:onAdded(function( ent )
    -- Callback for entity addition
    if ent:hasComponent("vy") or ent:hasComponent("vz") then
        table.insert(sortedMoveEnts, ent)
    else
        table.insert(sortedFrozenEnts, ent)
    end
end)



local function removeFrom()

drawGroup:onRemoved(function( ent )
    -- Callback for entity removal
    if ent:hasComponent("vy") or ent:hasComponent("vz") then
        table.insert(sortedMoveEnts, ent)
    else
        table.insert(sortedFrozenEnts, ent)
    end
end)




local rawget = rawget
local ipairs = ipairs
local setColor = graphics.setColor

local DEFAULT_ZOOM = constants.DEFAULT_ZOOM

local camera = cameraLib(0, 0, nil, nil, DEFAULT_ZOOM, 0)


local DEFAULT_LEIGHWAY = constants.SCREEN_LEIGHWAY


local function getScreenY(ent_or_y, z_or_nil)
    if type(ent_or_y) == "table" then
        return ent_or_y.y - (ent_or_y.z or 0)/2
    else
        return ent_or_y - (z_or_nil or 0)/2
    end
end


local function entOnScreen(ent, leighway, w, h)
    --[[
        `ent` the entity to be checked if on screen

        OPTIONAL:
        `leighway` the leighway given. If not supplied, a sensible
            default is provided.
        `w` and `h` are the width and height of the screen. 
            If these aren't supplied, they will be automatically given.
            It's slightly faster if they are supplied though.

        leighway is just a constant that determines how many pixels
        of "leighway" we can give each object before it's counted as offscreen
    ]]
    leighway = leighway or DEFAULT_LEIGHWAY
    w, h = w or graphics.getWidth(), h or graphics.getHeight()
    local screen_y = getScreenY(ent)
    local x, y = camera:toCameraCoords(ent.x, screen_y)

    local ret = -leighway <= x and x <= w + leighway
                and -leighway <= y and y <= h + leighway

    return ret
end


local function isOnScreen(x, y, leighway, w, h)
    --[[
        same as above, but for a direct x,y position as opposed to
        an entity.

        Assumes z = 0
    ]]
    leighway = leighway or DEFAULT_LEIGHWAY
    w, h = w or graphics.getWidth(), h or graphics.getHeight()
    x, y = camera:toCameraCoords(x, y)

    return -leighway <= x and x <= w + leighway
            and -leighway <= y and y <= h + leighway
end


local CAMERA_DEPTH_LEIGHWAY = 200
local function cameraTopDepth()
    local _, y = camera:toWorldCoords(0,-CAMERA_DEPTH_LEIGHWAY)
    return math.floor(y)
end

local function cameraBotDepth()
    local _, y = camera:toWorldCoords(0,graphics.getHeight() + CAMERA_DEPTH_LEIGHWAY)
    return math.floor(y)
end


local function mainDraw()
    local w, h = graphics.getWidth(), graphics.getHeight()
    for i=1, #sortedEntityArray do
        local ent = sortedEntityArray[i]
        if entOnScreen(ent, DEFAULT_LEIGHWAY, w, h) and (not ent.hidden) then
            setColor(1,1,1)
            if ent.image then
                if ent.color then
                    setColor(ent.color)
                end
                call("drawEntity", ent)
                if ent.onDraw then
                    ent:onDraw()
                end
            end
        end

        call("drawIndex", z_dep) -- TODO: do this
    end

    graphics.atlas:flush()
end


on("resize", function(w, h)
    camera.w = w
    camera.h = h
end)


local scaleUI = constants.DEFAULT_UI_SCALE

local function setUIScale(scale)
    assert(type(scale) == "number", "graphics.setUIScale(scale) requires a number")
    scaleUI = scale
end

local function getUIScale()
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





on("update", function(_)    
    camera:update()
end)



return {
    camera = camera;

    getScreenY = getScreenY;

    getUIScale = getUIScale;
    setUIScale = setUIScale;

    isOnScreen = isOnScreen;
    entOnScreen = entOnScreen
}


