


umg.on("@playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetEntityTypes", server.entities)
end)



server.on("worldeditorSpawnEntity", function(username, etypeName, x, y)
    local etype = server.entities[etypeName]
    etype(x, y)
end)






local function handleAdminCommand(sender, a,b,c,d)
    if a == true then
        -- turn worldedit mode on for this client
    else
        -- turn it off
    end
end



chat.handleAdminCommand("worldeditor", handleAdminCommand)
chat.handleAdminCommand("worldedit", handleAdminCommand)

