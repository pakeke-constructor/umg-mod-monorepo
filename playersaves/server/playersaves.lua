

-- Group of entities that are being controlled by players.
local control_ents = umg.group("controllable", "controller")




local EXTEN = ".playersaves_data"



local function get_filename(username)
    return username .. EXTEN
    -- Just some arbitrary extension so it's identifiable, and so
    -- that there are no filename collisions.
end




--[[
    this is a temporary table that keeps track of all players
    that have been in the game.
    It's only used if the world is NOT persistent;
    (if world is persistent, player-save-data is saved to disk instead)
]]
local player_data_cache = {--[[
    [ username ] -> player_pckr_data
]]}



local function load_data(username, entity_data)
    if entity_data then
        local res, err = umg.deserialize(entity_data)
        if ((not res) and err) then
            print("[playersaves]: couldn't deserialize player: ", err)
            umg.call("createPlayer", username)
        end
    else
        -- Welp, this player has no savedata!
        -- A newPlayer event is emitted, and a player should be created
        -- from that event somewhere.
        umg.call("createPlayer", username)
    end   
end



umg.on("@playerJoin", function(username)
    if server.isWorldPersistent() then
        -- load from file
        local fname = get_filename(username)
        local entity_data = server.load(fname)
        load_data(entity_data)
    else
        -- load from temp data cache
        load_data(player_data_cache[username])
        player_data_cache[username] = nil
    end
end)



local function save_data(username, entity_data)
    if server.isWorldPersistent() then
        -- world is persistent, so save to file
        local fname = get_filename(username)
        server.save(fname, entity_data)
    else
        -- non persistent, so we just put it in a temp cache.
        -- This way, if the player rejoins the server, they will have
        -- their player still.
        player_data_cache[username] = entity_data
    end
end



umg.on("@playerLeave", function(username)
    local buffer = {}
    for i=1, #control_ents do
        local ent = control_ents[i]
        if ent.controller == username then
            table.insert(buffer, ent)
        end
    end

    if #buffer > 0 then
        local entity_data = umg.serialize(buffer)
        --[[
            The reason we can serialize the buffer here, instead of each entity,
            is because when entities are deserialized, they are automatically put
            into systems.
            And since serialization / deserialization is done recursively, it
            doesn't matter that they are in a table- they will still be reached.
        ]]

        for i=1, #buffer do
            -- now delete all entities in the buffer
            buffer[i]:delete()
        end

        save_data(username, entity_data)
    end
end)


