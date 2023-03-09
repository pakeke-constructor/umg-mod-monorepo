

--[[
    TODO:
    Write the API here.

    We should be able to programmatically add our own tools and features
    to the worldeditor.
]]


local toolEditor = require("client.tool_editor")




client.on("worldeditorSetMode", function(a)
    _G.settings.editing = a
end)




local toolCache = {--[[
    keeps track of what brushes the server knows about
    [tool] --> toolName
]]}



local assertESKT = base.typecheck.assert("table", "string")


local function syncTool(tool, toolName)
    client.send("worldeditorDefineTool", tool, toolName)
end

local function ensureServerKnowsTool(tool, toolName)
    assertESKT(tool,toolName)
    if not toolCache[tool] then
        syncTool(tool, toolName)
    end
end






local toolHotkeys = {--[[
    [hotkey] --> tool
]]}



local currentEditNode



local currentTool
local currentToolName





umg.on("slabUpdate", function()
    if _G.settings.editing then
        Slab.BeginWindow("worldeditor", {Title = "World editor"})
        if Slab.Button("new brush") then
            local id = 1
            -- id of 1 for now is fine.
            currentEditNode = toolEditor.createBrushNode(id)
        end

        if currentEditNode then
            if Slab.Input('Tool name: ', {Text = currentToolName}) then
                currentToolName = Slab.GetInputText()
            end
            currentEditNode:display()
        end

        if currentToolName and #currentToolName > 0 and currentEditNode and currentEditNode:isDone() then
            currentTool = currentEditNode:getValue()
            syncTool(currentTool, currentToolName)
        end

        Slab.Text(" ")
        Slab.EndWindow()
    end
end)




local listener = base.input.Listener({priority = 1})


local function moveCamera(dt)
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
end




local BUTTON_1 = 1


local DONE_THIS_TICK = false

umg.on("@tick", function()
    DONE_THIS_TICK = true
end)


local function applyTool()
    if (not DONE_THIS_TICK) and listener:isMouseButtonDown(BUTTON_1) then
        local worldX, worldY = base.camera:getMousePosition()
        if currentTool and currentToolName then
            ensureServerKnowsTool(currentTool, currentToolName)
            client.send("worldeditorSetTool", currentToolName)
            client.send("worldeditorUseTool", currentToolName, worldX, worldY, BUTTON_1)
            DONE_THIS_TICK = true
        end
    end
end


function listener:update(dt)
    if _G.settings.editing then
        moveCamera(dt)
        applyTool()
        listener:lockKeyboard()
        listener:lockMouseButtons()
    end
end

