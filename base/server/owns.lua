
--[[


TODO:
Maybe remove this??
I dont think anything uses it.

also its kinda a bad way of doing things.



]]


local owners = umg.group("owns")



owners:onAdded(function(ent)
    if not ent.owns then
        ent.owns = data.Set()
    end
end)




owners:onRemoved(function(ent)
    -- `ent` has been deleted...
    -- Now, we must delete all entities that `ent` owns.
    local set = ent.owns
    for i=1, set:size() do
        local owned_ent = set:get(i)
        owned_ent:delete()
        umg.call("ownedEntityDeleted", owned_ent)
    end
end)



