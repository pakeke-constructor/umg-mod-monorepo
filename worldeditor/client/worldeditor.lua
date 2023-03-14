


local constants = require("shared.constants")

local toolEditor = require("client.tool_editor")




client.on("worldeditorSetMode", function(a)
    _G.settings.editing = a
    base.control.setFollowActive(not a)
end)




local knownTools = {--[[
    [name] --> toolInfo
]]}

local hotkeyToToolInfo = {--[[
    [hotkey] --> toolInfo
]]}


local currentHotKey = "1"



local ToolInfo = base.Class("worldeditor:ClientSideToolInfo")

function ToolInfo:init(options)
    self.tool = options.tool
    self.editNode = options.editNode
    self.name = options.name
    self.serverUpdated = false
    assert(self.tool and self.editNode and self.name, "?")
end








local function syncTool(tool, toolName)
    client.send("worldeditorDefineTool", tool, toolName)
end

local function ensureServerKnowsTool(toolInfo)
    if not toolInfo.serverUpdated then
        toolInfo.serverUpdated = true
        syncTool(toolInfo.tool, toolInfo.name)
    end
end


local function getCurrentToolInfo()
    return hotkeyToToolInfo[currentHotKey or ""]
end



local currentEditToolInfo





local buttonApplyColor = {0.2,0.8,0.3}
local toolNameColor = {0.8,0.8,0.2}
local toolTypeColor = {0.1,0.9,0.9}
local buttonCancelColor = {0.8,0.25,0.25}


local renderToolEditor
do

local currentTool
local currentToolName


function renderToolEditor()
    Slab.BeginWindow("Tool Editor", {Title = "Tool Editor"})

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

end



local renderHotkeyEditor
do

local validHotKeys = {
    q = true,
    e = true,
    r = true,
    f = true
}
for i=0,9 do
    validHotKeys[tostring(i)] = true
end


local makingNewHotKey = false
local newHotKey = nil

function renderHotkeyEditor()
    Slab.Text("Hotkey    Tool")
    if Slab.BeginTree("hotkeyEdit", {Label = "Hotkeys: "}) then
        Slab.Indent()
        for hotKey, toolInfo in pairs(toolHotkeys) do
            Slab.Text(hotKey)
            Slab.SameLine()
            if Slab.Button(toolInfo.name) then
                currentEditToolInfo = toolInfo
            end
        end

        if makingNewHotKey then
            if Slab.BeginComboBox('hotkey chooser', {Selected = newHotKey}) then
                for hk, _ in pairs(validHotKeys) do
                    if (not toolHotkeys[hk]) and Slab.TextSelectable(hk) then
                        newHotKey = hk
                    end
                end
                Slab.EndComboBox()
            end
            if Slab.Button("Cancel", {Color = buttonCancelColor}) then
                makingNewHotKey = false
                newHotKey = nil
            end
            Slab.SameLine()
        else
            if Slab.Button("New Hotkey", {Color = buttonApplyColor}) then
                makingNewHotKey = true
            end
        end

        Slab.Unindent()
        Slab.EndTree()
    end
end

end



umg.on("slabUpdate", function()
    if _G.settings.editing then
        Slab.Text("Current tool: TODO", {Color = {0.3,0.3,0.9}})

        if Slab.Button("Import hotkeys") then
            -- open import txt box
        end

        if Slab.Button("Export hotkeys") then
            -- open export txt box
        end

        --[[
            local id = 1
            -- id of 1 for now is fine.
            currentEditNode = toolEditor.createBrushNode(id)
            Slab.EndTree()
        ]]
    
        renderHotkeyEditor()
    end
end)



umg.on("postDrawWorld", function()
    if _G.settings.editing then
        love.graphics.push("all")
        love.graphics.setLineWidth(3)
        local currentTool = getCurrentToolInfo()
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


-- to ensure we only send one event across per tick
local DONE_THIS_TICK = false


umg.on("@tick", function()
    DONE_THIS_TICK = false
end)


local function applyTool(toolInfo)
    if (not DONE_THIS_TICK) and listener:isMouseButtonDown(BUTTON_1) then
        local worldX, worldY = base.camera:getMousePosition()
        ensureServerKnowsTool(toolInfo)
        client.send("worldeditorSetTool", toolInfo.name)
        client.send("worldeditorUseTool", toolInfo.name, worldX, worldY, BUTTON_1)
        DONE_THIS_TICK = true
    end
end




function listener:update(dt)
    if _G.settings.editing then
        moveCamera(dt)
        if currentTool and currentToolName and currentTool.useType == constants.USE_TYPE.CONTINUOUS then
            applyTool()
        end
        listener:lockKeyboard()
        listener:lockMouseButtons()
    end
end



function listener:mousepressed()
    if _G.settings.editing then
        if currentTool and currentToolName and currentTool.useType == constants.USE_TYPE.DISCRETE then
            applyTool()
        end
        DONE_THIS_TICK = true
    end
end

