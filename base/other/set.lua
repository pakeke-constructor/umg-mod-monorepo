
-- Need to make sure this is loaded; it may not be loaded yet
local Class = require("other.class")


local Set = Class("base_mod:Set")


function Set:init()
    self.objects  = {}
    self.pointers = {}
    self.size     = 0
end


--- Clears the sSet completely.
function Set:clear()
    local obj
    local objs = self.objects
    local ptrs = self.pointers
    for i=1, self.size do
        obj = objs[i]
        ptrs[obj] = nil
        objs[i] = nil    
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

   self.objects[size] = obj
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
        self.objects[size] = nil
    else
        local other = self.objects[size]

        self.objects[index]  = other
        self.pointers[other] = index

        self.objects[size] = nil
    end

    self.pointers[obj] = nil
    self.size = size - 1

    return self
end



-- Gets the object at `index` in the Set
function Set:get(index)
   return self.objects[index]
end


-- returns true if the Set contains `obj`, false otherwise.
function Set:has(obj)
   return self.pointers[obj] and true
end


export("Set", Set)

return Set

