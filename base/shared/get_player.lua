
local controllableGroup = umg.group("controllable", "controller")


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


controllableGroup:onAdded(function(ent)
    local uname = ent.controller
    if uname then
        username_to_ent[uname] = ent
        ent_to_username[ent] = uname
    end
end)


controllableGroup:onRemoved(function(ent)
    local uname = ent_to_username[ent] or ent.controller
    if uname then
        if username_to_ent[uname] == ent then
            username_to_ent[uname] = nil
        else
            -- well crap, looks like we gotta do a full search.
            -- operation is only O(n) complexity, where `n` is number of players. (not too bad)
            for uname2, ent2 in pairs(username_to_ent) do
                if ent2 == ent then
                    username_to_ent[uname2] = nil
                end
            end
        end
    end
    ent_to_username[ent] = nil
end)



local function findEnt(uname)
    -- I don't think we can do any better than a linear search
    -- (This should usually be fine, as it'll be cached)
    for _, ent in ipairs(controllableGroup) do
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
            uname = client.getUsername()
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
        local new_uname = ent.controller
        username_to_ent[new_uname] = ent
        ent_to_username[ent] = new_uname
        return ent
    end
end




return getPlayer
