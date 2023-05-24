
local Class = require("shared.class")

local Array = Class("base_mod:Array")



-- Initializes array
function Array:init(initial)
    self.len = 0

    if initial then
        if (type(initial) ~= "table") then
            error("Bad argument #1 to Array().\nexpected table, got: " .. tostring(type(initial)))
        end

        for i=1, #initial do
            self:add(initial[i])
        end
    end
end



-- Adds item to array
function Array:add(x)
    assert(x ~= nil, "cannot add nil to array")
    self.len = self.len + 1
    self[self.len] = x
end


-- Clears array
function Array:clear()
    for i=1, self.len do
        self[i] = nil
    end
    self.len = 0
end



-- Returns the size of the array
function Array:size()
    return self.len
end

Array.length = Array.size -- alias




-- Pops item from array at index
-- (if index is nil, pops from the end of array.)
function Array:pop(i)
    if i and (not (1 <= i and i <= self.len)) then
        error("Array index out of range: " .. tostring(i))
    end
    table.remove(self, i)
    self.len = self.len - 1
end


-- Pops item from array by swapping it with the last item
-- this operation is O(1)
-- WARNING: This operation DOES NOT preserve array order!!!
function Array:quickPop(i)
    local obj = self[self.len]
    self[i], self[self.len] = obj, nil
    self.len = self.len - 1
end




function Array:find(obj)
    -- WARNING: Linear search O(n)
    for i=1, self.len do
        if self[i] == obj then
            return i
        end
    end
    return nil
end


function Array:filter(func)
    local newArray = Array()
    for i=1, self.len do
        local item = self[i]
        if func(item) then
            newArray:add(item)
        end
    end
    return newArray
end



return Array
