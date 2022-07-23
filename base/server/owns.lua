
--[[


TODO:
Maybe remove this??
I dont think anything uses it.

also its kinda a bad way of doing things.



]]


local owners = group("owns")


-- Need to make sure this is loaded; it may not be loaded yet
local Set = require("other.set")


owners:onAdded(function(ent)
    if not ent.owns then
        ent.owns = Set()
    end
end)




owners:onRemoved(function(ent)
    -- `ent` has been deleted...
    -- Now, we must delete all entities that `ent` owns.
    local set = ent.owns
    for i=1, set:size() do
        local owned_ent = set:get(i)
        owned_ent:delete()
        call("ownedEntityDeleted", owned_ent)
    end
end)



