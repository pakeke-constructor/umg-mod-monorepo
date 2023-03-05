

--[[

brush objects

All table keys with `_` are temporary, and specific to the runtime.
When brushes are exported, keys starting with _ are ignored

]]
local SpawnRule = require("shared.action")


local Brush = base.Class("wordeditor:Brush")


local shapeType = {
    POINT = true,
    CIRCLE = true,
    SQUARE = true,
}


local actionType = {
    SPAWN  = true, -- spawnRule
    MACRO  = true, -- predefined macro. Must act on a position.
    SCRIPT = true -- runs a lua script. Takes a position (x,y) as input.
}


local actionPlacementType = {
    RANDOM_NORMAL = true,
    UNIFORM = true,
    RANDOM_UNIFORM = true
}

local actionPlacement_requireDistances = {
    UNIFORM = true
}

local actionPlacement_requireBounds = {
    RANDOM_NORMAL = true,
    RANDOM_UNIFORM = true
}




--[[
PLANNING:::

br.shape  = {
    shapeType  =  POINT | CIRCLE | SQUARE,
    size = 10
} 

br.action =  {
    actionType =  SPAWN | SCRIPT | MACRO,

    script = nil | luaCodeString
    spawnRule = nil | spawnRule
    macro = nil | macro
}

-- only if brushType is NOT "POINT":
br.actionPlacement = {
    actionPlacementType = UNIFORM | RANDOM_UNIFORM | RANDOM_NORMAL

    minDistance = 20 -- minimum distance between placed entities


    -- only needed for UNIFORM mode:
    xDistance = 5 -- x distance between entities
    yDistance = 5 -- y distance between entities

    -- Only needed for RANDOM modes:
    maxActions = 10,
    minActions = 5
}


]]

local coordCheck = base.typecheck.check("number", "number")


local function brushActionPlacementValid(pl)
    local typ = pl.actionPlacementType
    local typeOk = typ and actionPlacementType[typ]
    local distanceOk = true
    local boundsOk = true
    if actionPlacement_requireDistances[typ] then
        boundsOk = coordCheck(pl.xDistance, pl.yDistance)
    end
    if actionPlacement_requireBounds[typ] then
        distanceOk = coordCheck(pl.maxActions, pl.minActions) and pl.minActions < pl.maxActions
    end

    return typeOk and distanceOk and boundsOk
end



local function brushActionValid(action)
    if action.actionType == actionType.SPAWN then
        local spawnRule = action.spawnRule
        return spawnRule and SpawnRule.isValid(spawnRule)
    elseif action.actionType == actionType.SCRIPT then
        return false -- nyi
    elseif action.actionType == actionType.MACRO then
        return false -- nyi
    end
end



local function brushShapeOk(shape)
    local typ = shape.shapeType
    local typeOk = typ and shapeType[typ]
    local sizeOk = type(shape.size) == "number" or typ == shapeType.POINT
    return typeOk and sizeOk
end



function Brush.isValid(br)
    --[[
        checks if a brush representation is valid
    ]]
    local shapeOk = type(br.shape) == "table" and brushShapeOk(br.shape)
    local actionOk = brushActionValid(br.action)
    local placementOk = true
    if br.shape.shapeType ~= shapeType.POINT then
        placementOk = type(br.actionPlacement) == "table" and brushActionPlacementValid(br.actionPlacement)
    end
    return shapeOk and actionOk and placementOk
end



function Brush:init(options)

end



local function executeAction(action, x, y)
    if action.actionType == actionType.SPAWN then
        local spawnRule = action.spawnRule
        spawnRule:execute(x, y)
    elseif action.actionType == actionType.MACRO then
        error("nyi.")
    elseif action.actionType == actionType.SCRIPT then
        error("nyi!")
    end
end





local function randomUniformPosition(centerX, centerY, size)
    local rx = math.random()
    local ry = math.random()

    local x = math.floor(rx*size + centerX - size/2)
    local y = math.floor(ry*size + centerY - size/2)
    return x, y
end



local function randomNormalPosition(centerX, centerY, size)
    assert(width == height)
    local STDEV_MODIFIER = 2.5
    local stdev = STDEV_MODIFIER * size
    local x = love.math.randomNormal(stdev, centerX)
    local x = love.math.randomNormal(stdev, centerY)
    return math.floor(x), math.floor(y)
end


local function randomPosition(self, x, y)
    local ap = self.actionPlacement
    if ap.actionPlacementType == actionPlacementType.RANDOM_NORMAL then

    elseif ap.actionPlacementType == actionPlacementType.RANDOM_NORMAL then
        
    end
end


local function circleApply(self, x, y)
    local size = self.shape.size
    local action = self.action

    if actionPlacement
end



local function squareApply(self, x, y)

end



function Brush:use(x, y)
    

    self._lastUseX = x
    self._lastUseY = y
end







return Brush

