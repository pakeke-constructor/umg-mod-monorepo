

--[[

A bunch of useful functions that don't really belong elsewhere.

]]


local currentCamera = require("client.current_camera")
local entityProperties = require("client.helper.entity_properties")


local floor = math.floor

-- gets the "screen" Y from y and z position.
local function getDrawY(y, z)
    return y - (z or 0)/2
end


local function getDrawDepth(y,z)
    return floor(y + (z or 0))
end


local function getEntityDrawDepth(ent)
    local depth = ent.drawDepth or 0
    return getDrawDepth((ent.y or 0) + depth, ent.z)
end




local DEFAULT_LEIGHWAY = constants.SCREEN_LEIGHWAY
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()




local function isOnScreen(dVec, leighway)
    -- Returns true if a dimensionVector is on screen
    -- false otherwise.
    local x, y, dimension = dVec.x, getDrawY(dVec.y), dVec.dimension
    local w,h = screenWidth, screenHeight
    local camera = currentCamera.getCamera()
    if camera:getDimension() ~= dimension then
        return false -- camera is looking at a different dimension
    end
    leighway = leighway or DEFAULT_LEIGHWAY
    w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()
    x, y = camera:toCameraCoords(x, y)

    return -leighway <= x and x <= w + leighway
            and -leighway <= y and y <= h + leighway
end




local getOpacity, getColor = entityProperties.getOpacity, entityProperties.getColor
local isHidden = entityProperties.isHidden

local setColor = love.graphics.setColor



local function setColorOfEnt(ent)
    local r,g,b = getColor(ent)
    local a = getOpacity(ent)
    setColor(r,g,b,a)
end



local function drawEntity(ent)
    if isOnScreen(ent) and not isHidden(ent) then
        setColorOfEnt(ent)
        umg.call("rendering:preDrawEntity", ent)
        umg.call("rendering:drawEntity", ent)
        if ent.onDraw then
            ent:onDraw()
        end
        umg.call("rendering:postDrawEntity", ent)
    end
end






return {
    getDrawY = getDrawY,
    getDrawDepth = getDrawDepth,
    getEntityDrawDepth = getEntityDrawDepth,

    isOnScreen = isOnScreen,
    drawEntity = drawEntity
}
