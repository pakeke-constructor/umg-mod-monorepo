

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

function Grid:get(x,y)
    gridXYAsserter(self,x,y)
    x = math.floor(x / self.width)
    y = math.floor(y / self.height)
    -- short circuit so we don't generate a new table thru __index
    return rawget(self.array, x) and self.array[x][y]
end



function Grid:getPosition(entity_or_x, y_or_nil)
    local x, y
    if entity_or_x.x then
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

    local x = math.floor(ent.x / ent.grid.width)
    local y = math.floor(ent.y / ent.grid.height)
    local grd = getGrid(gridType, ent.grid.width, ent.grid.height)
    if umg.exists(grd:get(x,y)) and server then
        base.kill(grd:get(x,y)) -- kill old entity
    end
    grd.array[x][y] = ent
    ent.x = math.floor(x)
    ent.y = math.floor(y)
end)



gridGroup:onRemoved(function(ent)
    local gridType = ent.grid.type or ent:type()
    local x = math.floor(ent.x / ent.grid.width)
    local y = math.floor(ent.y / ent.grid.height)
    local grd = gridMap[gridType]
    if grd and ent == grd:get(x,y) then
        grd.array[x][y] = nil
    end
end)






local asserter = base.typecheck.assert("string")

function grids.getGrid(name_or_entity)
    if name_or_entity.type then
        return gridMap[name_or_entity:type()]
    else
        asserter(name_or_entity)
        return gridMap[name_or_entity]
    end
end




umg.expose("grids", grids)

return grids

