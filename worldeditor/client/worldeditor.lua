

local constants = require("shared.constants")

local sharing = require("client.sharing")
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

local function setHotKey(hotkey, toolInfo)
    hotkeyToToolInfo[hotkey] = toolInfo
end

local function deleteHotKey(hotkey)
    setHotKey(hotkey, nil)
end


local function defineNewToolInfo(toolInfo)
    assert(toolInfo:allReady(), "?")
    nameToToolInfo[toolInfo.name] = toolInfo
end


local function deleteToolInfo(toolInfo)
    nameToToolInfo[toolInfo.name] = nil
    for hk, tinfo in pairs(hotkeyToToolInfo)do
        if tinfo == toolInfo then
            -- if the tool info is being used by a hotkey, delete it.
            deleteHotKey(hk)
        end
    end
end



local currentToolInfoEditing

local function openToolEditor(toolInfo)
    currentToolInfoEditing = toolInfo
end

local function closeToolEditor()
    currentToolInfoEditing = nil
end



local buttonApplyColor = {0.2,0.8,0.3}
local nameColor = {0.8,0.8,0.2}
local typeColor = {0.1,0.9,0.9}
local buttonCancelColor = {0.8,0.25,0.25}
local buttonOtherColor = {0.65,0.65,0.2}
local buttonEditColor = {0.21,0.21,0.9}


local renderToolEditor
do

local lastExportTime = -10000
local EXPORT_HOVER_TIME = 5 -- seconds to hover export message


function renderToolEditor()
    local toolInfo = currentToolInfoEditing
    Slab.BeginWindow("Tool Editor", {Title = "Tool Editor"})

    if toolInfo then
        local editNode = toolInfo.editNode
        
        Slab.Text("Tool name: ", {Color = nameColor})
        Slab.SameLine()
        -- Don't allow for changing a tool's name after it's been created.
        if not toolInfo:allReady() then
            if Slab.Input('worldeditor : toolName', {Text = toolInfo.name}) then
                toolInfo.name = Slab.GetInputText()
            end
        else
            Slab.Text(toolInfo.name)
        end

        Slab.Text("tool: ", {Color = typeColor})
        editNode:display()

        if toolInfo.name and editNode:isDone() then
            if Slab.Button("Apply", {Color = buttonApplyColor}) then
                toolInfo.tool = editNode:getValue()
                syncTool(toolInfo)
                toolInfo.serverUpdated = true
                defineNewToolInfo(toolInfo)
            end
            if Slab.Button("Export to clipboard", {Color = buttonOtherColor}) then
                sharing.exportToClipboard(toolInfo.name, toolInfo, "TOOL")
                lastExportTime = love.timer.getTime()
            end
            if lastExportTime+EXPORT_HOVER_TIME > love.timer.getTime() then
                Slab.Text("Tool copied to clipboard!")
            end
        end
    end

    Slab.SameLine()
    Slab.Text("   ")
    if Slab.Button("Delete", {Color = buttonCancelColor}) then
        deleteToolInfo(toolInfo)
        closeToolEditor()
    end

    Slab.Text(" ")
    if Slab.Button("Exit", {Color = buttonCancelColor}) then
        closeToolEditor()
    end
    Slab.EndWindow()
end

end



local renderHotkeyDropDown
do

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
    if not Slab.BeginTree("hotkey maker", {Label = "Hotkeys: "}) then
        return
    end
    Slab.Indent()

    Slab.Text("hotKey: ", {Color = typeColor})
    Slab.SameLine()
    if Slab.BeginComboBox('hotkey chooser', {Selected = newHotKey}) then
        for hk, _ in pairs(validHotKeys) do
            if (not hotkeyToToolInfo[hk]) and Slab.TextSelectable(hk) then
                newHotKey = hk
            end
        end
        Slab.EndComboBox()
    end

    Slab.Text("tool: ", {Color = typeColor})
    Slab.SameLine()
    local curSel = selectedToolInfo and selectedToolInfo.name or nil
    if newHotKey and Slab.BeginComboBox("tool chooser", {Selected = curSel}) then
        for name,tinfo in pairs(nameToToolInfo) do
            if Slab.TextSelectable(name) then
                selectedToolInfo = tinfo
            end
        end
        Slab.EndComboBox()
    end
    if newHotKey and curSel and Slab.Button("Create HotKey", {Color = buttonApplyColor}) then
        setHotKey(newHotKey, selectedToolInfo)
        resetHotKeyEditState()
    end

    Slab.Text(" ")

    if Slab.Button("Cancel", {Color = buttonCancelColor}) then
        resetHotKeyEditState()
    end

    Slab.Unindent()
    Slab.EndTree()
end


--[[
    Responsible for rendering the full hotkey dropdown.
]]
function renderHotkeyDropDown()
    if Slab.BeginTree("hotkeyEdit", {Label = "Hotkeys: "}) then
        Slab.Indent()
        if Slab.Button("Import", {Color = buttonOtherColor}) then
            -- open import txt box, allow to paste stuff in
        end
        Slab.SameLine()
        if Slab.Button("Export", {Color = buttonOtherColor}) then
            -- Copy hotkeys to clipboard
        end

        if next(hotkeyToToolInfo) then
            for hotKey, toolInfo in pairs(hotkeyToToolInfo) do
                Slab.Text(hotKey)
                Slab.SameLine()

                if Slab.BeginComboBox("hk tool chooser", {Selected = toolInfo.name}) then
                    for name,tinfo in pairs(nameToToolInfo) do
                        if Slab.TextSelectable(name) then
                            setHotKey(hotKey, tinfo)
                            break
                        end
                    end
                    Slab.EndComboBox()
                end
                Slab.SameLine()
                if Slab.Button("Edit tool", {Color = buttonEditColor}) then
                    openToolEditor(toolInfo)
                end
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




local renderToolDropDown
do

function renderToolDropDown()
    if Slab.BeginTree("tool list", {Label = "Tools: "}) then     
        if Slab.Button("Define New Tool", {Color = buttonApplyColor}) then
            -- give the editNode an id of one here. This assumes that two different 
            -- tools can't be edited simultaneously.
            local editNode = toolEditor.createBrushNode(1)
            -- create new tool info, and open it in the editor
            local toolInfo = ToolInfo({
                editNode = editNode,
            })
            openToolEditor(toolInfo)
        end

        for tname, tinfo in pairs(nameToToolInfo) do
            Slab.Text(tname)
            Slab.SameLine()
            if Slab.Button("Edit", {Color = buttonEditColor}) then
                openToolEditor(tinfo)
                break
            end
        end
        Slab.EndTree()
    end
end

end






do


umg.on("slabUpdate", function()
    if _G.settings.editing then
        Slab.BeginWindow("worldedit main win", {Title = "worldeditor"})

        do -- render current tool
        local tinfo = getCurrentToolInfo()
        local tname = tinfo and tinfo.name or "none"
        Slab.Text("Current tool: " .. tname, {Color = {0.7,0.7,1}})
        Slab.Text(" ")
        end

        renderToolDropDown()
        renderHotkeyDropDown()

        Slab.EndWindow()

        if currentToolInfoEditing then
            renderToolEditor()
        end
    end
end)


end


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
    if (not DONE_THIS_TICK) then
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
        if tinfo and tinfo.tool.useType == constants.USE_TYPE.CONTINUOUS then
            if listener:isMouseButtonDown(BUTTON_1) then
                applyTool(tinfo)
            end
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
            applyTool(tinfo)
        end
    end
end

