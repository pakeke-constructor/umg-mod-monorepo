

-- ABSTRACT BASE CLASS
local AreaAction = objects.Class("worldeditor:AreaAction")

AreaAction.toolType = "AreaAction"


local AreaScriptAction = objects.Class("worldeditor:AreaScriptAction", AreaAction)
local AreaEntityAction = objects.Class("worldeditor:AreaEntityAction", AreaAction)
local AreaRandomPointAction = objects.Class("worldeditor:AreaRandomPointAction", AreaAction)
local AreaGridPointAction = objects.Class("worldeditor:AreaGridPointAction", AreaAction)
local AreaSelection = objects.Class("worldeditor:AreaSelection", AreaAction)
local AreaCommand = objects.Class("worldeditor:AreaCommand", AreaAction)


local areaActions = {
    AreaRandomPointAction,
    AreaGridPointAction,
    AreaEntityAction
}



local inAreaAssert = typecheck.assert("number", "number", "table")

local function inArea(x,y, area)
    inAreaAssert(x,y,area)
    local ex, ew, ey, eh = area.x, area.w, area.y, area.h
    local withinExclusion = ex<x and ex+ew>x and ey<y and ey+eh>y
    return withinExclusion
end



local function applyPointAction(pointBuffer, pointAction, excludeArea)
    for _, point in ipairs(pointBuffer) do
        local x,y = point[1], point[2]
        if not inArea(x,y, excludeArea) then
            x = math.floor(x)
            y = math.floor(y)
            pointAction:apply(x,y)
        end
    end
end



-- AreaRandomPointAction START
local randomTypes = {
    NORMAL = "NORMAL",
    UNIFORM = "UNIFORM"
}

local DEFAULT_MIN_POINT_DISTANCE = 10

function AreaRandomPointAction:init(params)
    self.numPoints = params.numPoints
    self.type = params.type
    assert(self.type and randomTypes[self.type], "Invalid distribution type: " .. tostring(self.type))
    self.minDistance = params.minDistance or DEFAULT_MIN_POINT_DISTANCE
    self.pointAction = params.pointAction
    assert(params.pointAction, "?")
end


AreaRandomPointAction.params = {
    {param = "numPoints", type = "number"},
    {param = "pointAction", type = "PointAction"},
    {param = "type", type = "selection", options = {randomTypes.NORMAL, randomTypes.UNIFORM}},
    {param = "minDistance", type = "number", optional = true},
}


local function generateRandomPoint(self, x, y, w, h)
    local centerX = x + w/2
    local centerY = y + h/2
    if self.type == randomTypes.NORMAL then
        local STDEV_MOD = 2.5
        local xx = love.math.randomNormal(STDEV_MOD*w, centerX)
        local yy = love.math.randomNormal(STDEV_MOD*h, centerY)
        return math.floor(xx), math.floor(yy)    
    elseif self.type == randomTypes.UNIFORM then
        local rx = math.random()
        local ry = math.random()
        return math.floor(rx*w + x), math.floor(ry*h + y)
    end
    error("eh?")
end

local MAX_TRIES = 4


local function hasPointWithinRange(pointBuffer, minDistance, x, y)
    -- TODO: This is O(n^2) in the context of the parent function!! 
    -- Creating a temporary spatial partition would a pretty good idea here.
    for _, point in ipairs(pointBuffer)do
        if math.distance(x-point[1], y-point[2]) < minDistance then
            return true
        end
    end
    return false
end

local assertNumbers4 = typecheck.assert("number","number","number","number")

function AreaRandomPointAction:apply(area, excludeArea)
    assert(server, "?")
    local x,y,w,h = area.x, area.y, area.w, area.h
    assertNumbers4(x,y,w,h)
    local pointBuffer = objects.Array()
    for _=1, self.numPoints do
        for _=1, MAX_TRIES do
            local px, py = generateRandomPoint(self, x, y, w, h)

            if not hasPointWithinRange(pointBuffer, self.minDistance, px, py) then
                pointBuffer:add({px,py})
                break
            end
        end
    end
    applyPointAction(pointBuffer, self.pointAction, excludeArea)
end

AreaRandomPointAction.name = "Area Random PointAction"
AreaRandomPointAction.description ="Generates random points, then applies action to them"
-- AreaRandomPointAction END












-- AreaGridPointAction START

local assertNumbers = typecheck.assert("number","number")

function AreaGridPointAction:init(params)
    assertNumbers(params.pointGapX, params.pointGapY)
    assert(params.pointAction, "?")
    self.pointGapX = params.pointGapX
    self.pointGapY = params.pointGapY
    self.pointAction = params.pointAction
end

function AreaGridPointAction:apply(area, excludeArea)
    local x,y,w,h = area.x, area.y, area.w, area.h
    assertNumbers4(x,y,w,h)

    local pointBuffer = objects.Array()
    for xx = x, x+w, math.max(1, self.pointGapX) do
        for yy = y, y+h, math.max(1, self.pointGapY) do
            pointBuffer:add({xx,yy})
        end
    end
    applyPointAction(pointBuffer, self.pointAction, excludeArea)
end

AreaGridPointAction.name = "Area Grid PointAction"
AreaGridPointAction.description = "Generates grid points, then applies action to them"

AreaGridPointAction.params = {
    {param = "pointGapX", type = "number"},
    {param = "pointGapY", type = "number"},
    {param = "pointAction", type = "PointAction"},
}
-- AreaGridPointAction END













-- AreaEntityAction START

function AreaEntityAction:init(params)
    assert(params.entityAction, "?")
    self.entityAction = params.entityAction
end

function AreaEntityAction:apply(area, excludeArea)
    local x,y,w,h = area.x, area.y, area.w, area.h
    assertNumbers4(x,y,w,h)

    for ent in chunks.iterator(x,y) do
        if inArea(ent.x,ent.y, area) and (not inArea(ent.x, ent.y, excludeArea)) then
            self.entityAction:apply(ent)
        end
    end
end

AreaEntityAction.name = "Area Entity Action"
AreaEntityAction.description = "Applies action to entities in an area"

AreaEntityAction.params = {
    {param = "entityAction", type = "EntityAction"}
}
-- AreaEntityAction END







return areaActions

