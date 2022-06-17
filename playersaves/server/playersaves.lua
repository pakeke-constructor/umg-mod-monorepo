

-- Group of entities that are being controlled by players.
local control_ents = group("controllable", "controller")




local function get_filename(username)
    return username .. ".playersaves_data"
    -- Just some arbitrary extension so it's identifiable, and so
    -- that there are no filename collisions.
end



on("playerJoin", function(username)
    local fname = get_filename(username)
    local entity_data = load(fname)

    if entity_data then
        deserialize(entity_data)
    else
        -- Welp, this player has no savedata!
        -- A newPlayer event is emitted, and a player should be created
        -- from that event somewhere.
        call("newPlayer", username)
    end
end)




on("leave", function(username)
    local fname = get_filename(username)

    local buffer = {}
    for i=1, #control_ents do
        local ent = control_ents[i]
        if ent.controller == username then
            table.insert(buffer, ent)
        end
    end

    if #buffer > 0 then
        local entity_data = serialize(buffer)
        --[[
            The reason we can serialize the buffer here, instead of each entity,
            is because when entities are deserialized, they are automatically put
            into systems.
            And since serialization / deserialization is done recursively, it
            doesn't matter that they are in a table- they will still be reached.
        ]]
        save(fname, entity_data)
    end
end)


