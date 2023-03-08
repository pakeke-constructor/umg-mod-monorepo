

--[[
    TODO:
    Write the API here.

    We should be able to programmatically add our own tools and features
    to the worldeditor.
]]


local toolEditor = require("client.tool_editor")



local currentEditNode

local currentBrush


umg.on("slabUpdate", function()
    Slab.BeginWindow("worldeditor", {Title = "World editor"})
    if Slab.Button("new brush") then
        local id = 1
         -- id of 1 for now is fine.
        currentEditNode = toolEditor.createBrushNode(id)
    end

    if currentEditNode then
        currentEditNode:display()
    end

    if currentEditNode and currentEditNode:isDone() then
        currentBrush = currentEditNode:getValue()
    end
    Slab.EndWindow()
end)




local listener = base.input.Listener({priority = 1})


function listener:update(dt)
    if _G.settings.active then
        local dx = 0
        local dy = 0
        local delta = base.camera.scale * dt

        if listener:isControlDown(base.input.UP) then
            dy = dy - delta
        end
        if listener:isControlDown(base.input.DOWN) then
            dy = dy + delta
        end
        if listener:isControlDown(base.input.LEFT) then
            dx = dx - delta
        end
        if listener:isControlDown(base.input.RIGHT) then
            dx = dx + delta
        end
        base.camera.x = base.camera.x + dx
        base.camera.y = base.camera.y + dy
       
        listener:lockKeyboard()
        listener:lockMouseButtons()
    end
end


