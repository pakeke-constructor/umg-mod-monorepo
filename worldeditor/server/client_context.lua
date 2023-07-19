
local ClientContext = objects.Class("worldeditor:ClientContext")


function ClientContext:init(username)    
    self.username = username
    self.tools = {--[[
        [toolName] --> Tool
    ]]}
    self.currentTool = "toolName"
end



function ClientContext:getCurrentTool()
    return self.tools[self.currentTool]
end



function ClientContext:defineTool(tool, toolName)
    self.tools[toolName] = tool
end


function ClientContext:setCurrentTool(toolName)
    self.currentTool = toolName
end



return ClientContext
