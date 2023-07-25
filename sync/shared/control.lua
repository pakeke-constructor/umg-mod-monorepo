
--[[

Determines whether an entity is controllable by the client, or not.

]]


local control = {}



function control.getController(ent)
    --[[
        returns the controlling clientId for `ent`,
        (or nil if there is none.)
    ]]

    if not ent.controllable then
        return nil -- Not controllable, so return nil.
        -- The reason we must do this check is for efficiency reasons.
        -- autoSyncComponent in the sync mod will (indirectly) trigger
        -- this function call once for EVERY packet being synced...
        -- so we need this func to be fast.
        -- We can't afford doing a `umg.ask` for every fakken packet!!
    end

    if ent.controller then
        -- trivial case
        return ent.controller
    end

    -- else, poll thru question bus
    --[[
        TODO: Use a better reducer for this. 
        when multi-return question buses get supported, perhaps
        return (client-id, priority)
    ]]
    return umg.ask("getController", reducers.LAST, ent)
end



local getController = control.getController

function control.isControlledBy(ent, clientId)
    --[[
        Checks is an entity is controllable by clientId
    ]]
    local controller = getController(ent)
    local ok = controller == clientId

    if ok then
        -- check that it's not blocked
        local blocked = umg.ask("isControlBlocked", reducers.OR, ent, clientId)
        return not blocked
    end
end



function control.isClientControlling(ent)
    assert(client, "Can't be called on server!")
    return control.isControlledBy(ent, client.getUsername())
end


return control
