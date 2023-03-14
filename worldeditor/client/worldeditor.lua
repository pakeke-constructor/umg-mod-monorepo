

local constants = require("shared.constants")

local toolEditor = require("client.tool_editor")




client.on("worldeditorSetMode", function(a)
    _G.settings.editing = a
    base.control.setFollowActive(not a)
end)




local validHotKeys = {
    q = true,
    e = true,
    r = true,
    f = true
}
for i=0,9 do
    validHotKeys[tostring(i)] = true
end



local nameToToolInfo = {--[[
    [name] --> toolInfo
]]}


local hotkeyToToolInfo = {--[[
    [hotkey] --> toolInfo
]]}


local currentHotKey = "1"



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






local function syncTool(toolInfo)
    client.send("worldeditorDefineTool", toolInfo.tool, toolInfo.name)
end

local function ensureServerKnowsTool(toolInfo)
    if not toolInfo.serverUpdated then
        toolInfo.serverUpdated = true
        syncTool(toolInfo)
    end
end


local function getCurrentToolInfo()
    return hotkeyToToolInfo[currentHotKey or ""]
end

local function defineHotKey(hotkey, toolInfo)
    hotkeyToToolInfo[hotkey] = toolInfo
end



local currentToolInfoEditing





local buttonApplyColor = {0.2,0.8,0.3}
local toolNameColor = {0.8,0.8,0.2}
local toolTypeColor = {0.1,0.9,0.9}
local buttonCancelColor = {0.8,0.25,0.25}


local renderToolEditor
do

local name


function renderToolEditor(toolInfo)
    Slab.BeginWindow("Tool Editor", {Title = "Tool Editor"})

    if toolInfo then
        local editNode = toolInfo.editNode
        Slab.Text("Tool name: ", {Color = toolNameColor})
        Slab.SameLine()
        if Slab.Input('worldeditor : toolName', {Text = name}) then
            name = Slab.GetInputText()
        end
        Slab.Text("tool: ", {Color = toolTypeColor})
        editNode:display()

        if name and editNode:isDone() and Slab.Button("Apply", {Color = buttonApplyColor}) then
            toolInfo.tool = editNode:getValue()
            toolInfo.name = name
            syncTool(toolInfo)
            toolInfo.serverUpdated = true
        end
    end

    Slab.Text(" ")
    Slab.EndWindow()
end

end



local renderHotkeyEditor
do



local idCount = 1 -- This is kinda shit. 
-- Slab requires UI ids to be unique... but we are just generating numbers here.
-- We need to be careful of imported tools having duplicate IDs.
-- I think it's "fine" for now, since you can only edit one node at once.
-- Also you will never render multiple tools in one window context, so its probs fine

local idIncrement = 200 -- assumes that editNodes won't have more than this many children


local makingNewHotKey = false
local newHotKey = nil

local selectedToolInfo = nil


local function resetHotKeyEditState()
    makingNewHotKey = false
    newHotKey = nil
    selectedToolInfo = nil
end


--[[
    This function is responsible for rendering
    a single hotkey editor
]]
local function renderSingleHotKeyMaker()
    if Slab.BeginComboBox('hotkey chooser', {Selected = newHotKey}) then
        for hk, _ in pairs(validHotKeys) do
            if (not hotkeyToToolInfo[hk]) and Slab.TextSelectable(hk) then
                newHotKey = hk
            end
        end
        Slab.EndComboBox()
    end

    if currentToolInfoEditing then
        if currentToolInfoEditing:allReady() then
            local tinfo = currentToolInfoEditing
            nameToToolInfo[tinfo.name] = tinfo
        end
    else
        if newHotKey and Slab.BeginComboBox("tool chooser", {Selected = selectedToolInfo.name}) then
            for name,tinfo in pairs(nameToToolInfo) do
                if Slab.TextSelectable(name) then
                    selectedToolInfo = tinfo
                end
            end
            Slab.EndComboBox()
            if Slab.Button("Create HotKey", {Color = buttonApplyColor}) then
                defineHotKey(selectedToolInfo.name, selectedToolInfo)
                resetHotKeyEditState()
            end
        end
        if Slab.Button("New Tool") then
            local editNode = toolEditor.createBrushNode(idCount)
            currentToolInfoEditing = ToolInfo({
                editNode = editNode,
            })
            idCount = idCount + idIncrement
        end
    end
    
    if Slab.Button("Cancel", {Color = buttonCancelColor}) then
        resetHotKeyEditState()
    end
    Slab.EndTree()
end


--[[
    This the the "big cheese" so to speak.
    It's responsible for rendering the full hotkey editor.
]]
function renderHotkeyEditor()
    Slab.Text("Hotkey    Tool")
    if Slab.BeginTree("hotkeyEdit", {Label = "Hotkeys: "}) then
        Slab.Indent()
        for hotKey, toolInfo in pairs(hotkeyToToolInfo) do
            Slab.Text(hotKey)
            Slab.SameLine()
            if Slab.Button(toolInfo.name) then
                currentToolInfoEditing = toolInfo
            end
        end

        if makingNewHotKey then
            renderSingleHotKeyMaker()
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
        local tinfo = getCurrentToolInfo()
        if tinfo and tinfo.tool.useType == constants.USE_TYPE.DISCRETE then
            applyTool()
        end
        listener:lockKeyboard()
        listener:lockMouseButtons()
    end
end


function listener:keypressed(key, scancode)
    if validHotKeys[scancode] then
        currentHotKey = scancode
    end
end


function listener:mousepressed()
    if _G.settings.editing then
        local tinfo = getCurrentToolInfo()
        if tinfo and tinfo.tool.useType == constants.USE_TYPE.DISCRETE then
            applyTool()
        end
        DONE_THIS_TICK = true
    end
end

