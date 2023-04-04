
-- Need to make sure this is loaded; it may not be loaded yet
local Class = require("shared.class")


local Set = Class("base:Set")


function Set:init(initial)
    self.pointers = {}
    self.size     = 0
    if initial then
        for i=1, #initial do
            self:add(initial[i])
        end
    end
end


--- Clears the sSet completely.
function Set:clear()
    local obj
    local ptrs = self.pointers
    for i=1, self.size do
        obj = self[i]
        ptrs[obj] = nil
        self[i] = nil    
    end

    self.size = 0
    return self
end



-- Adds an object to the Set
function Set:add(obj)
   if self:has(obj) then
      return self
   end

   local size = self.size + 1

   self[size] = obj
   self.pointers[obj] = size
   self.size          = size

   return self
end





-- Removes an object from the Set.
-- If the object isn't in the Set, returns nil.
function Set:remove(obj, index)
    if not obj then
        return nil
    end
    if not self.pointers[obj] then
        return nil
    end

    index = index or self.pointers[obj]
    local size  = self.size

    if index == size then
        self[size] = nil
    else
        local other = self[size]

        self[index]  = other
        self.pointers[other] = index

        self[size] = nil
    end

    self.pointers[obj] = nil
    self.size = size - 1

    return self
end



-- returns true if the Set contains `obj`, false otherwise.
function Set:has(obj)
   return self.pointers[obj] and true
end

Set.contains = Set.has -- alias



return Set

