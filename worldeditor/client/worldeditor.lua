

--[[
    TODO:
    Write the API here.

    We should be able to programmatically add our own tools and features
    to the worldeditor.
]]


local toolEditor = require("client.tool_editor")



local currentEditNode

local currentBrush



umg.on("slabUpdate", function(listener)
    if Slab.Button("new brush") then
        local id = 1
         -- id of 1 for now is fine.
        currentEditNode = toolEditor.createBrushNode(id)
    end

    if currentEditNode then
        currentEditNode:display()
    end

    if currentEditNode:isDone() then
        currentBrush = currentEditNode:getValue()
    end
end)


local listener = base.input.Listener({priority = 1})


function listener:update(dt)

    listener:lockMouseButtons()
end


