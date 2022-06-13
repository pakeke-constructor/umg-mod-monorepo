
local Array = Class("base_mod:Array")



-- Initializes array
function Array:init(arr_initial)
    self.len = 0

    if arr_initial then
        if (type(arr_initial) ~= "table") then
            error("Bad argument #1 to Array().\nexpected table, got: " .. tostring(type(arr_initial)))
        end

        for i=1, #arr_initial do
            self:add(arr_initial[i])
        end
    end
end



-- Adds item to array
function Array:add(x)
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




export("Array", Array)

return Array
