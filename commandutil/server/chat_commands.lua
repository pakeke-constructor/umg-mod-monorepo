
--[[
    TODO:
]]



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


