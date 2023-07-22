
--[[

Determines whether an entity is controllable by the client, or not.

]]


local function isControllable(ent, user)
    local ok = ent.controllable == user or umg.ask("isControllable", reducers.OR, ent, user)

    if ok then
        local blocked = umg.ask("isControlBlocked", reducers.OR, ent, user)
        return not blocked
    end
    return false
end



return isControllable

