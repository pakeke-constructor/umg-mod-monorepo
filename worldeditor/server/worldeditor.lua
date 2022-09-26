


on("playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetETypes", entities)
end)



server.on("worldeditorSpawnEntity", function(username, ...)
    --TODO.
end)


