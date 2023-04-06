
chat.handleCommand("script", {
    handler = function(sender)
        server.unicast(sender, "chatCommandsOpenScript")
    end,

    adminLevel = 100,
    arguments = {}
})




chat.handleCommand("run", {
    handler = function(sender, script)
        if type(script) ~= "string" then
            chat.privateMessage(sender, "invalid usage: /run <luaScript>")
            return
        end
        local chunk = pcall(loadstring, script)
        if not chunk then
            chat.privateMessage(sender, "invalid syntax: /run <luaScript>")
        end
    
        local success, err = pcall(chunk)
        if not success then
            chat.privateMessage("error running script: " .. err)
        end
    end,

    adminLevel = 100,
    arguments = {{name = "script", type = "string"}}
})




local PLAYER_SPAWN_OFFSET = 30

chat.handleCommand("spawn", {
    arguments = {
        {name = "entType", type = "string"}
    },
    adminLevel = 50,

    handler = function(sender, entType)
        if server.entities[entType] then
            local p = base.getPlayer(sender)
            local x,y = 0,0
            if p then
                x,y = p.x, p.y + PLAYER_SPAWN_OFFSET
            end
            server.entities[entType](x,y)
        else
            chat.message("SPAWN FAILED: Unknown entity type " .. tostring(entType))
        end
    end
})


