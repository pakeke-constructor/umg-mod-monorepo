

local grids = {}

local gridGroup = umg.group("grid", "x", "y")




local Grid = base.Class("grid:Grid")




local gridMap = {--[[
    [gridType] => Grid
]]}






--[[
    These are just 2d arrays;

    local ar2d = make2dArray()
    ar2d[x][y] = "foobar"
]]
local function make2dArray()
    return setmetatable({}, {
        __index = function(t,k)
            t[k] = {}
            return t[k]
        end
    })
end




local gridInitAsserter = base.typecheck.assert("string", "number", "number")

function Grid:init(name, width, height)
    gridInitAsserter(name, width, height)
    self.array = make2dArray()
    self.name = name
    self.width = width
    self.height = height
end


local gridXYAsserter = base.typecheck.assert("table", "number", "number")

function Grid:get(gridX, gridY)
    gridXYAsserter(self,gridX,gridY)
    -- short circuit so we don't generate a new table thru __index
    return rawget(self.array, gridX) and self.array[gridX][gridY]
end


function Grid:_set(x,y,ent)
    --[[
        this ideally shouldn't be used outside of this file
    ]]
    self.array[x][y] = ent
end


function Grid:getPosition(entity_or_x, y_or_nil)
    local x, y
    if type(entity_or_x) == "table" then
        local ent = entity_or_x
        x, y = ent.x, ent.y
    else
        x, y = entity_or_x, y_or_nil        
    end
    gridXYAsserter(self, x, y)

    return math.floor(x / self.width), math.floor(y / self.height)
end




local function assertGridComponentValid(ent)
    local g = ent.grid
    assert(g.width and g.height, "needs grid width and height")
end



local function getGrid(gridType, width, height)
    if not gridMap[gridType] then
        gridMap[gridType] = Grid(gridType, width, height)
    end
    return gridMap[gridType]
end



gridGroup:onAdded(function(ent)
    assert(type(ent.grid) == "table", "grid component must be a table")
    assert(ent.x and ent.y, "grid entities must have x,y components")
    assert(not (ent.vx or ent.vy), "grid entities must stay still")
    assertGridComponentValid(ent)
    local gridType = ent.grid.type or ent:type()

    local w,h = ent.grid.width, ent.grid.height
    local x = math.floor(ent.x / w)
    local y = math.floor(ent.y / h)
    local grd = getGrid(gridType, w, h)
    if grd:get(x,y) and server then
        base.server.kill(grd:get(x,y)) -- kill old entity
    end
    grd:_set(x,y,ent)
    ent.x = math.floor(x) * w
    ent.y = math.floor(y) * h
end)



gridGroup:onRemoved(function(ent)
    local gridType = ent.grid.type or ent:type()
    local x = math.floor(ent.x / ent.grid.width)
    local y = math.floor(ent.y / ent.grid.height)
    local grd = gridMap[gridType]
    if grd and ent == grd:get(x,y) then
        grd:_set(x,y,nil)
    end
end)






local asserter = base.typecheck.assert("string | table")

function grids.getGrid(name_or_entity)
    asserter(name_or_entity)
    local typ
    if type(name_or_entity) == "string" then
        typ = name_or_entity
    else
        local ent = name_or_entity
        if not ent.type then
            error("expected an entity as an argument")
        end
        typ = (ent.grids and ent.grids.type) or ent:type()
    end
    return gridMap[typ]
end




return grids

