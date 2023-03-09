

--[[
    TODO:
    Write the API here.

    We should be able to programmatically add our own tools and features
    to the worldeditor.
]]


local toolEditor = require("client.tool_editor")




client.on("worldeditorSetMode", function(a)
    _G.settings.editing = a
    base.control.setFollowActive(not a)
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
        toolCache[tool] = toolName
        syncTool(tool, toolName)
    end
end






local toolHotkeys = {--[[
    [hotkey] --> tool
]]}



local currentEditNode



local currentTool
local currentToolName



local buttonApplyColor = {0.2,0.8,0.3}
local toolNameColor = {0.8,0.8,0.2}
local toolTypeColor = {0.1,0.9,0.9}


umg.on("slabUpdate", function()
    if _G.settings.editing then
        Slab.BeginWindow("worldeditor", {Title = "World editor"})
        if Slab.Button("new brush") then
            local id = 1
            -- id of 1 for now is fine.
            currentEditNode = toolEditor.createBrushNode(id)
        end

        if currentEditNode then
            Slab.Text("Tool name: ", {Color = toolNameColor})
            Slab.SameLine()
            if Slab.Input('worldeditor : toolName', {Text = currentToolName}) then
                currentToolName = Slab.GetInputText()
            end
            Slab.Text("tool: ", {Color = toolTypeColor})
            currentEditNode:display()
        end

        if currentToolName and #currentToolName > 0 and currentEditNode and currentEditNode:isDone() then
            if Slab.Button("Apply", {Color = buttonApplyColor}) then
                currentTool = currentEditNode:getValue()            
                syncTool(currentTool, currentToolName)
            end
        end
        Slab.Text(" ")
        Slab.EndWindow()
    end
end)



umg.on("postDrawWorld", function()
    if _G.settings.editing then
        love.graphics.push("all")
        love.graphics.setLineWidth(3)
        if currentTool and currentTool.draw then
            local x, y = base.camera:getMousePosition()
            currentTool:draw(x,y)
        end
        love.graphics.pop()
    end
end)




local listener = base.input.Listener({priority = 1})


local CAMERA_SPEED = 800

local function moveCamera(dt)
    local dx = 0
    local dy = 0
    local delta = CAMERA_SPEED * dt / base.camera.scale

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

    local x,y = base.camera.x + dx, base.camera.y + dy
    base.camera:follow(x,y)
end




local BUTTON_1 = 1


local DONE_THIS_TICK = false

umg.on("@tick", function()
    DONE_THIS_TICK = false
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


function listener:mousepressed(dt)

end

