
local control_ents = group("controllable", "controller")


-- Mapping from username -> control ent.
local username_to_ent = {
--[[
    [username] -> ent
]]
}


-- Gotta keep backrefs so no memory leaks
-- (Since the value of `controller` could be changed at runtime, 
-- we have to keep track of it here.)
local ent_to_username = {
--[[
    [ent] -> username
]]
}


control_ents:onAdded(function(ent)
    local uname = ent.controller
    username_to_ent[uname] = ent
    ent_to_username[ent] = uname
end)


control_ents:onRemoved(function(ent)
    local uname = ent_to_username[ent]
    if username_to_ent[uname] == ent then
        username_to_ent[uname] = nil
    end
    ent_to_username[ent] = nil
end)



local function findEnt(uname)
    -- I don't think we can do any better than a linear search
    -- (This should usually be fine, as it'll be cached)
    for _, ent in ipairs(control_ents) do
        if ent.controller == uname then
            return ent
        end
    end
end



local function getPlayer(uname)
    if not uname then
        if server then
            error("getPlayer expects a username as first argument.")            
        else
            uname = username -- `username` is the client's username. 
        end
    end

    if username_to_ent[uname] then
        local candidate_ent = username_to_ent[uname]
        if candidate_ent.controller == uname then
            return candidate_ent
        end
        -- Else:
        -- Oh crap! candidate entity is no longer being controlled by `uname`!
    end

    local ent = findEnt(uname)
    if ent then
        username_to_ent[username] = ent
        ent_to_username[ent] = username
        return ent
    end
end




return getPlayer
