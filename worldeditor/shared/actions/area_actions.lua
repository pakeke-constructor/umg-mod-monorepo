

-- ABSTRACT BASE CLASS
local AreaAction = base.Class("worldeditor:AreaAction")

local AreaScriptAction = base.Class("worldeditor:AreaScriptAction", AreaAction)
local AreaEntityAction = base.Class("worldeditor:AreaEntityAction", AreaAction)
local AreaRandomPointAction = base.Class("worldeditor:AreaRandomPointAction", AreaAction)
local AreaGridPointAction = base.Class("worldeditor:AreaGridPointAction", AreaAction)
local AreaSelection = base.Class("worldeditor:AreaSelection", AreaAction)
local AreaCommand = base.Class("worldeditor:AreaCommand", AreaAction)


local areaActions = {
    AreaRandomPointAction = AreaRandomPointAction,
    AreaGridPointAction = AreaGridPointAction
}





local function applyPointAction(pointBuffer, pointAction, excludeArea)
    for _, point in ipairs(pointBuffer) do
        local x,y = point[1], point[2]
        local ex, ew, ey, eh = excludeArea.x, excludeArea.w, excludeArea.y, excludeArea.h
        local withinExclusion = ex<x and ex+ew>x and ey<y and ey+eh>y
        if not withinExclusion then
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
    assert(self.type and randomTypes[self.type], "bad AreaRandomPointAction params")
    self.type = params.type
    self.minDistance = DEFAULT_MIN_POINT_DISTANCE
    self.pointAction = params.pointAction
    assert(params.pointAction, "?")
end


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

local assertNumbers4 = base.typecheck.assert("number","number","number","number")

function AreaRandomPointAction:apply(area, excludeArea)
    local x,y,w,h = area.x, area.y, area.w, area.h
    assertNumbers4(x,y,w,h)
    local pointBuffer = base.Array()
    for _=1, self.numPoints do
        for _=1, MAX_TRIES do
            local px, py = generateRandomPoint(self, x, y)

            if not hasPointWithinRange(pointBuffer, self.minDistance, px, py) then
                pointBuffer:add({px,py})
                break
            end
        end
    end
    applyPointAction(pointBuffer, self.pointAction, excludeArea)
end
-- AreaRandomPointAction END












-- AreaUniformPointAction START

local assertNumbers = base.typecheck.assert("number","number")

function AreaGridPointAction:init(params)
    assertNumbers(params.pointGapX, params.pointGapY)
    assert(params.pointAction, "?")
    self.pointGapX = params.pointGapX
    self.pointGapX = params.pointGapX
    self.pointAction = params.pointAction
end

function AreaGridPointAction:apply(area, excludeArea)
    local x,y,w,h = area.x, area.y, area.w, area.h
    assertNumbers4(x,y,w,h)

    local pointBuffer = base.Array()
    for xx = x, w, self.pointGapX do
        for yy = y, h, self.pointGapY do
            pointBuffer:add({xx,yy})
        end
    end
    applyPointAction(pointBuffer, self.pointAction, excludeArea)
end
-- AreaUniformPointAction END








return areaActions

