
--[[

Determines whether an entity is controllable by the client, or not.


pros / cons of this setup:



PROS:
allows for more dynamic changes

allows for swift changes in control




CONS:
entities could be controlled by multiple players at once, causing bugs

on clientside, the client must loop over all entities per tick to check for syncs.
- as opposed to only looping over entities with `controllable` component

]]


local function isControllable(ent, user)
    local ok = (ent.controllable == user) or umg.ask("isControllable", reducers.OR, ent, user)

    if ok then
        local blocked = umg.ask("isControlBlocked", reducers.OR, ent, user)
        return not blocked
    end

    return false
end



return isControllable

