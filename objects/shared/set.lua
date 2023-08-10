
-- Need to make sure this is loaded; it may not be loaded yet
local Class = require("shared.class")


local Set = Class("objects:Set")


function Set:init(initial)
    self.pointers = {}
    self.len     = 0
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
    for i=1, self.len do
        obj = self[i]
        ptrs[obj] = nil
        self[i] = nil    
    end

    self.len = 0
    return self
end



-- Adds an object to the Set
function Set:add(obj)
   if self:has(obj) then
      return self
   end

   local sze = self.len + 1

   self[sze] = obj
   self.pointers[obj] = sze
   self.len          = sze

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
    local sze  = self.len

    if index == sze then
        self[sze] = nil
    else
        local other = self[sze]

        self[index]  = other
        self.pointers[other] = index

        self[sze] = nil
    end

    self.pointers[obj] = nil
    self.len = sze - 1

    return self
end


function Set:length()
    return self.len
end

Set.size = Set.length -- alias



-- returns true if the Set contains `obj`, false otherwise.
function Set:has(obj)
   return self.pointers[obj] and true
end

Set.contains = Set.has -- alias



return Set

