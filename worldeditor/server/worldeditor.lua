


umg.on("@playerJoin", function(username)
    -- Send etypes over so the client knows about them
    server.unicast(username, "worldeditorSetEntityTypes", server.entities)
end)




local function mouseAction(sender,x,y,button)

end


server.on("worldeditorMouseAction", function(sender, x,y,button)
    if chat.isAdmin(sender) then
        mouseAction(sender,x,y,button)
    end
end)




local BOOL_ALIASES = {
    on = true,
    off = false
}

local function handleAdminCommand(sender, a,b,c,d)
    if BOOL_ALIASES[a] then
        a = BOOL_ALIASES[a]
    end
    if a == true or a == false then
        server.unicast(sender, "worldeditorSetMode", a)
    end
    -- TODO:
    -- Can do other stuff here.
    -- perhaps fudge with settings and whatnot?
    -- eg    /worldeditor settings.xyz foo
end



chat.handleAdminCommand("worldeditor", handleAdminCommand)
chat.handleAdminCommand("worldedit", handleAdminCommand)

