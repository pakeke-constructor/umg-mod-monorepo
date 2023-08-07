

local chat = {}


if server then

local chatServ = require("server.chat")
chat.getAdminLevel = chatServ.getAdminLevel
chat.setAdminLevel = chatServ.setAdminLevel
chat.message = chatServ.message
chat.privateMessage = chatServ.privateMessage

end


local commands = require("shared.commands")

chat.handleCommand = commands.handleCommand
chat.getCommands = commands.getCommands




umg.expose("chat", chat)

return chat
