


umg.on("@playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetEntityTypes", server.entities)
end)



server.on("worldeditorSpawnEntity", function(username, etypeName, x, y)
    local etype = server.entities[etypeName]
    etype(x, y)
end)


