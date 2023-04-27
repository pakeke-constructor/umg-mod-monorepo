
chat.handleCommand("script", {
    handler = function(sender)
        server.unicast(sender, "chatCommandsOpenScript")
    end,

    adminLevel = 100,
    arguments = {}
})




chat.handleCommand("run", {
    handler = function(sender, script)
        local success, err, chunk
        success, chunk = pcall(loadstring, script)
        if not success then
            chat.privateMessage(sender, "invalid syntax: /run <luaScript>")
            return
        end
    
        success, err = pcall(chunk)
        if not success then
            chat.privateMessage(sender, "error running script: " .. err)
        end
    end,

    adminLevel = 100,
    arguments = {{name = "script", type = "string"}}
})


chat.handleCommand("tickrate", {
    handler = function(sender, tickrate)
        local succ, err = pcall(server.setTickrate, tickrate)
        if not succ then
            chat.privateMessage(sender, "error setting tickrate: " .. tostring(err))
        end
    end,

    adminLevel = 100,
    arguments = {{name = "tickrate", type = "number"}}
})



chat.handleCommand("position", {
    handler = function(sender)
        local player = base.getPlayer(sender)
        if player and player.x and player.y then
            chat.privateMessage(sender, ("(%.1f, %.1f)"):format(player.x, player.y))
        end
    end,

    adminLevel = 0,
    arguments = {}
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


