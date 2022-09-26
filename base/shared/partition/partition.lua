
--[[

spatial_partition module

partition expects all entities added to have a `x` and `y` component



TODO::
Pretty much all of this code is really scuffed.
All of this needs a redo.

Start by removing the closure_cache nonsense, and replace it with proper
stateless iterators.


]]




local floor = math.floor


local Partition = {}

local Set = require("shared.set")


local mt = {__index = function(t,k)
    t[k] = setmetatable({}, {__index = function(te,ke)
        te[ke] = Set()
        return te[ke]
    end})
    return t[k]
end}



local partitions = {}



function Partition:new(size_x, size_y)
    local new = {}
    new.size_x = size_x
    new.size_y = size_y
        
    --[[
        The last x and y position of each object in the spatial hash.
        (As in, the position of the object the last time it was updated.)
    ]]
    new.currentXIndex = {}
    new.currentYIndex = {}

    new.moving_objects = Set()

    for k, v in pairs(self) do
        new[k] = v
    end

    local partition = setmetatable(new, mt)
    table.insert(partitions, partition)
    return partition
end



function Partition:clear()
    for key, _ in pairs(self) do
        if type(key) == "number" then
            for _, set_ in pairs(self[key]) do
                set_:clear( )
            end
        end
    end
end



on("update", function(dt)
    for _, partition in ipairs(partitions)do
        partition.updated_this_frame = false
    end
end)




function Partition:contains(object)
    return self.currentXIndex[object] and self.currentYIndex[object]
end


function Partition:update()
    self.updated_this_frame = true
    for _, obj in self.moving_objects:iter() do
        self:updateObj(obj)
    end
end



function Partition:updateObj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:getSet(obj):remove(obj)   -- Same as self:___rem(obj)
    local indexX = floor(obj.x/self.size_x)
    local indexY = floor(obj.y/self.size_y)
    self.currentXIndex[obj] = indexX
    self.currentYIndex[obj] = indexY
    self[indexX][indexY]:add(obj)
end



function Partition:___add(obj)
    local indexX = floor(obj.x/self.size_x)
    local indexY = floor(obj.y/self.size_y)
    self.currentXIndex[obj] = indexX
    self.currentYIndex[obj] = indexY
    self[indexX][indexY]:add(obj)
end



function Partition:___rem(obj)
    self:getSet(obj):remove(obj)
    self.currentXIndex[obj] = nil
    self.currentYIndex[obj] = nil
end



function Partition:setPosition(obj, x, y)
    --[[
        Note that the user must change the x,y fields independently,
        after this function has been called
    ]]
    self:___rem(obj)
    local indexX = floor(x/self.size_x) 
    local indexY = floor(y/self.size_y)
    self.currentXIndex[obj] = indexX
    self.currentYIndex[obj] = indexY
    self[indexX][indexY]:add(obj)
end



function Partition:add(obj)
    self.moving_objects:add(obj)
    self:___add(obj)
end


function Partition:remove(obj)
    if self:contains(obj) then
        self.moving_objects:remove(obj)
        self:___rem(obj)
    end
end


function Partition:size(x,y)
    --returns the size of the cell at x, y
    return #(self[floor(x/self.size_x)][floor(y/self.size_y)].objects)
end


function Partition:frozenAdd(obj)
    -- This obj stays in a constant position.
    -- Much more efficient for updating- use when possible
    self:___add(obj)
end




function Partition:getSet(obj)
    local x, y = self.currentXIndex[obj], self.currentYIndex[obj]
    local set_ = self[x][y]
    
    -- Try for easy way out: Assume the object hasn't moved out of it's cell
    if set_:has(obj) then
        return set_, x, y
    end

    for X = x-1, x+1 do
        for Y = y-1, y+1 do
            set_ = self[X][Y]
            if set_:has(obj) then
                return set_, X, Y
            end
        end
    end
    -- Object has moved further than it's cell neighbourhood boundary.
    -- Throw err
    error("What? obj disappeared from partition... this is a bug with partition.lua I think")
end






function Partition:setGetters( x_getter, y_getter )
    assert(type(x_getter) == "function", "expected type function, got type:  " .. tostring(type(x_getter)))
    assert(type(y_getter) == "function", "expected type function, got type:  " .. tostring(type(y_getter)))
    self.___getx = x_getter
    self.___gety = y_getter
    self.getSet = self.moddedGetSet
    self.___add = self.modded____add
    self.updateObj = self.moddedUpdateObj
end




-- Iteration handling... here we go
do
    -- local x, y, set_, current, X, Y, sel  <OLD VARS>
    local _ -- (tells _G we arent making globals)

    local closure_caches = { }
    -- holds a table that keeps track of the instances of loops that are currently
     -- running. This way, we can have nested loops.
     -- TODO: This can be made more efficient if we instead return values from the func

    local iter
    iter = function( )
        -- `inst` is a reference to this loop instances closure environment.
        -- again, this is done so nested loops are possible.
        local inst = closure_caches[#closure_caches]

        -- If we are at end of set:
        if inst.set_.size < inst.current + 1 then
            if (inst.X-inst.x) < 1 then -- (X-x) will vary from -1 to 1. Same for (Y-y).
                inst.X = inst.X + 1
                inst.set_ = inst.sel[inst.X][inst.Y] -- change sets.
                inst.current = 0 -- reset counter
                return iter()  -- try again; iteration failed
            else
                if (inst.Y-inst.y) < 1 then
                    inst.Y = inst.Y + 1
                    inst.X = inst.x - 1 -- revert X to base case.
                    inst.set_ = inst.sel[inst.X][inst.Y] -- change sets.
                    inst.current = 0 -- reset counter
                    return iter() -- try again; iteration failed

                else -- Else, we have ended iteration, as Y and X have reached above the cell boundaries.
                    inst.set_=nil
                    inst.sel=nil -- (incase Partition is deleted, we dont want a memory leak)
                    closure_caches[#closure_caches] = nil -- pop this iteration state from stack
                    return nil
                end
            end
        else
            inst.current = inst.current + 1
            return inst.set_.objects[inst.current]
        end
    end


    -- Iterates over spacial Partition that `obj_or_x` is in. (including `obj`)
    -- If `x` and `y` are numbers, will iterate over that spacial positioning Partition.
    
    function Partition:iter(obj_or_x ,y_)
        if not y_ then
            assert(exists(obj_or_x), "Partition:iter(ent) requires an entity as an argument.\nThe partition will iterate objects surrounding the entity.")
        else
            assert(type(obj_or_x) == "number" and type(y_) == "number", "Partition:iter(x,y) requires numbers as an iteration target area")
        end
        local inst = { } -- The state of this iteration.
                         -- We can't use closures, because locals are shared
        table.insert(closure_caches, inst)
        
        if not self.updated_this_frame then
            self:update()
        end

        if y_ then
            -- obj is a number in this scenario; equivalent to  x.
            inst.x = floor(obj_or_x/self.size_x)
            inst.y = floor(y_/self.size_y)
            inst.set_ = self[inst.x-1][inst.y-1]
            assert(inst.set_, "Problem in spacial partitioner. `set_` is nil")
        else
            _, inst.x, inst.y = self:getSet(obj_or_x)
            inst.set_ = self[inst.x-1][inst.y-1]
            assert(inst.set_, "Problem in spacial partitioner. `set_` is nil")
        end

        inst.X = inst.x-1
        inst.Y = inst.y-1
        inst.current = 0
        inst.sel = self

        return iter
    end


    --    local lx, ly, l_set_, lcurrent, lX, lY, lsel
     -- holds a table that keeps track of the instances of loops that are currently
     -- running. This way, we can have nested loops.
    local l_closure_caches = { }

    local longiter
    longiter = function( )
        local inst = l_closure_caches[#l_closure_caches]
        -- If we are at end of set:
        if inst.l_set_.size < inst.lcurrent + 1 then
            if (inst.lX-inst.lx) < 2 then -- (lX-lx) will varly from -1 to 1. Same for (lY-ly).
                inst.lX = inst.lX + 1
                inst.l_set_ = inst.lsel[inst.lX][inst.lY] -- change sets.
                inst.lcurrent = 0 -- reset counter
                return longiter()  -- try again; iteration failed
            else
                if (inst.lY-inst.ly) < 2 then
                    inst.lY = inst.lY + 1
                    inst.lX = inst.lx - 2 -- revert lX to base case.
                    inst.l_set_ = inst.lsel[inst.lX][inst.lY] -- change sets.
                    inst.lcurrent = 0 -- reset counter
                    return longiter() -- trly again; iteration failed

                else -- Else, we have ended iteration, as lY and lX have reached above the cell boundaries.
                    inst.l_set_=nil
                    inst.lsel=nil -- (incase Partition is deleted, we dont want a memorly leak)
                    l_closure_caches[#l_closure_caches]=nil --pop from stack
                    return nil
                end
            end
        else
            inst.lcurrent = inst.lcurrent + 1
            return inst.l_set_.objects[inst.lcurrent]
        end
    end


    function Partition:longiter(obj_or_x, y_)
        local inst = {} -- The state of this iteration.
                        -- We can't use closures, because locals are shared
        table.insert(l_closure_caches, inst)

        if not self.updated_this_frame then
            self:update()
        end

        if y_ then
            -- obj is a number in this scenario; equivalent to  lx.
            inst.lx = floor(obj_or_x/self.size_x)
            inst.ly = floor(y_/self.size_y)
            inst.l_set_ = self[inst.lx-1][inst.ly-1]
        else
            _, inst.lx, inst.ly = self:getSet(obj_or_x)
            inst.l_set_ = self[inst.lx-1][inst.ly-1]
        end

        inst.lX = inst.lx-2
        inst.lY = inst.ly-2
        inst.lcurrent = 0
        inst.lsel = self

        return longiter
    end

    -- Aliases
    Partition.each = Partition.iter
    Partition.foreach = Partition.iter
    Partition.loop = Partition.iter

    Partition.longeach = Partition.longiter
    Partition.longforeach = Partition.longiter
    Partition.longloop = Partition.longiter
end



return function(size_x, size_y)
    size_x = size_x or error("A cell-size is needed to make spacial partitioner")
    size_y = size_y or size_x

    return Partition:new(size_x, size_y)
end


