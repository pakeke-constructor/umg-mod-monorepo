


umg.on("playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetETypes", server.entities)
end)



server.on("worldeditorSpawnEntity", function(username, ...)
    --TODO.
end)


