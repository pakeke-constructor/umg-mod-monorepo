
local ClientContext = base.Class("worldeditor:ClientContext")


function ClientContext:init(username)    
    self.username = username
    self.tools = {--[[
        [number] --> Brush
    ]]}
end


function ClientContext:getTool(id)
    return self.tools[id]
end


function ClientContext:setTool(id, tool)
    self.tools[id] = tool
end
