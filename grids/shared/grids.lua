

local grids = {}

local gridGroup = umg.group("grid", "x", "y")




local Grid = base.Class("grid:Grid")




local gridMap = setmetatable({--[[
    [gridType] => Grid
]]}, {
    __index = function(t,k)
        t[k] = Grid()
        return t[k]
    end
})






--[[
    These are just 2d arrays;

    local ar2d = make2dArray()
    ar2d[x][y] = "foobar"
]]
local function make2dArray(init)
    return setmetatable(init, {
        __index = function(t,k)
            t[k] = {}
            return t[k]
        end
    })
end




local gridInitAsserter = base.typecheck.asserter("string", "number", "number")

function Grid:init(name, width, height)
    self.array = make2dArray()
    self.name = name
    self.width = width
    self.height = height
end


function Grid:get(x,y)
    x = math.floor(x / self.width)
    y = math.floor(y / self.height)
    -- short circuit so we don't generate a new table thru __index
    return rawget(self.array, x) and self.array[x][y]
end


local getPositionAsserter = base.typecheck.asserter("table", "number", "number")

function Grid:getPosition(entity_or_x, y_or_nil)
    local x, y
    if entity_or_x.x then
        local ent = entity_or_x
        x, y = ent.x, ent.y
    else
        x, y = entity_or_x, y_or_nil        
    end
    getPositionAsserter(self, x, y)

    return math.floor(x / self.width), math.floor(y / self.height)
end


function Grid:





local function assertGridComponentValid(ent)
    local g = ent.grid
    assert(g.width and g.height, "needs grid width and height")
end



gridGroup:onAdded(function(ent)
    assert(ent.x and ent.y, "grid entities must have x,y components")
    assert(not (ent.vx or ent.vy), "grid entities must stay still")
    assertGridComponentValid(ent.grid)
    local gridType = ent.grid.type or ent:type()

    local x = math.floor(ent.x / ent.grid.width)
    local y = math.floor(ent.y / ent.grid.height)
    local grd = gridMap[gridType]
    if not umg.exists(grd[x][y]) then
        grd[x][y] = ent
    end
end)



gridGroup:onRemoved(function(ent)
    local gridType = ent.grid.type or ent:type()
    local x = math.floor(ent.x / ent.grid.width)
    local y = math.floor(ent.y / ent.grid.height)
    local grd = gridMap[gridType]
    if ent == grd[x][y] then
        grd[x][y] = nil
    end
end)






local asserter = base.typecheck.asserter("string")

function grids.getGrid(name_or_entity)
    local g
    if name_or_entity.type then
        return gridMap[name_or_entity:type()]
    else
        asserter(name_or_entity)
        return gridMap[name_or_entity]
    end
end




umg.expose("grids", grids)

return grids

