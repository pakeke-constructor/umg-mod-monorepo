

local Class = require("shared.class")


local EntityRef = Class("objects:EntityRef")




-- Initializes EntityRef
function EntityRef:init(entity)
    assert(umg.exists(entity), "Entity didn't exist!")

    self.id = entity.id
    self.isValid = true
end




function EntityRef:changeReference(newEntity)
    self.id = newEntity.id
    self.isValid = true
end




function EntityRef:get()
    if not self.isValid then
        return nil
    end

    local ent = umg.getEntity(self.id)
    if not umg.exists(ent) then
        self.isValid = false
        return nil
    end

    return ent
end

