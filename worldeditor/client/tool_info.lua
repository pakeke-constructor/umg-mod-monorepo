

--[[

A Client-Side object that represents a tool on the client.

Contains the editNode that is capable of changing the tool.
Also contains it's name, and whether the server is updated about it's state.

]]

local ToolInfo = base.Class("worldeditor:ClientSideToolInfo")

function ToolInfo:init(options)
    self.editNode = options.editNode
    self.tool = options.tool or nil
    self.name = options.name or nil
    self.serverUpdated = false
end

function ToolInfo:allReady()
    return self.name and self.editNode and self.tool
end

function ToolInfo:setIsSynced(boolean)
    self.serverUpdated = boolean
end

function ToolInfo:isSynced()
    return self.serverUpdated
end


return ToolInfo
