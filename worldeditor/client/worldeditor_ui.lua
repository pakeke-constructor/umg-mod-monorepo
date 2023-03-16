

local sharing = require("client.sharing")
local toolEditor = require("client.tool_editor")

local ToolInfo = require("client.tool_info")


local worldeditUI = {}


-- `we` is just the world-edit internally used API
local we = nil 
function worldeditUI.init(worldeditAPI)
    we = worldeditAPI
end


-- easy access for enums
local HOTKEYS = sharing.packageTypes.HOTKEYS
local TOOL = sharing.packageTypes.TOOL





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





--[[
    ImportStates are defined as so:

    importState = {
        text = text,  -- input text
        expectedType = sharing.packageTypes.TOOL

        result = nil,  (may be nil)
        error = nil, (may be nil)
        shouldExit = false 
    }
]]
local newImportStateTC = base.typecheck.assert("string")
local function newImportState(expectedType)
    newImportStateTC(expectedType)
    assert(sharing.packageTypes[expectedType], "?")
    return {
        text = "",
        expectedType = expectedType,
        result = nil,
        error = nil,
        shouldExit = false,
    }
end


local function renderImportUI(importState)
    if Slab.Input("importTextBox", {Text = tostring(importState.text), H = 70, W = 200}) then
        importState.text = Slab.GetInputText()
    end
    if Slab.Button("Apply", {Color = buttonOtherColor}) then
        local package
        package, importState.error = sharing.import(importState.text)
        if package and package.object then
            importState.result = package.object
            if package.type ~= importState.expectedType then
                importState.error = "Bad import type, expected: " .. importState.expectedType
                importState.result = nil
            end
        else
            importState.result = nil
        end
    end
    Slab.SameLine()
    Slab.Text("  ")
    if Slab.Button("Cancel", {Color = buttonCancelColor}) then
        importState.shouldExit = true
    end
    if importState.error then
        Slab.Text("Error on import: ")
        Slab.Text(tostring(importState.error), {Color = buttonCancelColor})
    end
    Slab.Text(" ")
    return importState
end



local EXPORT_HOVER_TIME = 5 -- seconds to hover export message

local renderExportTC = base.typecheck.assert("string", "string", "table", "number")
-- eg:  lastExportTime = renderExportUI( "tool", lastExportTime, toolInfo.name, toolInfo )
local function renderExportUI(packageType, exportName, exportObject, lastExportTime)
    renderExportTC(packageType, exportName, exportObject, lastExportTime)
    assert(sharing.packageTypes[packageType], "?")
    if Slab.Button("Export " .. packageType, {Color = buttonOtherColor}) then
        sharing.exportToClipboard(exportName, exportObject, packageType)
        lastExportTime = love.timer.getTime()
    end
    if lastExportTime+EXPORT_HOVER_TIME > love.timer.getTime() then
        Slab.Text("Tool copied to clipboard!")
    end
    return lastExportTime
end






local renderToolEditor
do

local lastExportTime = -10000

local DELETE_CONFIRM_TIME = 4
local lastDeleteClick = -10000


--[[
    renders a window for editing tools.

    NOTE: Only one instance of this window should be open at once!!!
    This is because it uses global state through `currentToolInfoEditing`
]]
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
                we.syncTool(toolInfo)
                toolInfo.serverUpdated = true
                we.defineNewToolInfo(toolInfo)
                closeToolEditor()
            end
            Slab.SameLine()
            Slab.Text("   ")
            Slab.SameLine()
            lastExportTime = renderExportUI(
                TOOL, toolInfo.name,
                toolInfo, lastExportTime
            )
        end
    end

    Slab.Text(" ")
    if Slab.Button("Exit", {Color = buttonOtherColor}) then
        closeToolEditor()
    end

    if toolInfo then
        -- deleting of tool
        Slab.SameLine()
        Slab.Text("    ")
        Slab.SameLine()
        if Slab.Button("Delete Tool", {Color = buttonCancelColor}) then
            lastDeleteClick = love.timer.getTime()
        end
        if lastDeleteClick+DELETE_CONFIRM_TIME > love.timer.getTime() and Slab.Button("Confirm delete?", {Color = buttonCancelColor}) then
            we.deleteToolInfo(toolInfo)
            closeToolEditor()
        end
    end

    Slab.EndWindow()
end

end



local renderHotkeyDropDown
do

local makingNewHotKey = false
local newHotKey = nil

local selectedToolInfo = nil

local lastExportTime = -10000

local importHotKeyState = nil


local function resetHotKeyEditState()
    makingNewHotKey = false
    newHotKey = nil
    selectedToolInfo = nil
    importHotKeyState = nil
end


--[[
    This function is responsible for rendering
    a single hotkey editor
]]
local function renderSingleHotKeyMaker()
    local hotkeyToToolInfo = we.getHotkeyToToolInfoMap()
    local nameToToolInfo = we.getNameToToolInfoMap()

    if not Slab.BeginTree("hotkey maker", {Label = "Create hotkey: "}) then
        return
    end
    Slab.Indent()

    Slab.Text("hotKey: ", {Color = typeColor})
    Slab.SameLine()
    if Slab.BeginComboBox('hotkey chooser', {Selected = newHotKey}) then
        for _, hk in pairs(we.getHotkeys()) do
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
        we.defineHotKey(newHotKey, selectedToolInfo)
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
    local hotkeyToToolInfo = we.getHotkeyToToolInfoMap()
    local nameToToolInfo = we.getNameToToolInfoMap()

    if Slab.BeginTree("hotkeyEdit", {Label = "Hotkeys: "}) then
        Slab.Indent()
        if Slab.Button("Import", {Color = buttonOtherColor}) then
            importHotKeyState = newImportState(HOTKEYS)
        end
        Slab.SameLine()
        lastExportTime = renderExportUI(HOTKEYS, "Hotkeys", we.getHotkeyToToolInfoMap(), lastExportTime)
        
        if importHotKeyState then
            renderImportUI(importHotKeyState)
            if importHotKeyState.result then
                if Slab.Button("Finalize (overwrite)", {Color = buttonApplyColor}) then
                    local hotKeys = importHotKeyState.result
                    for hotkey, tinfo in pairs(hotKeys)do
                        we.defineHotKey(hotkey, tinfo)
                    end
                    importHotKeyState = nil
                end
            end
            if importHotKeyState.shouldExit then
                importHotKeyState = nil
            end
        end

        if next(hotkeyToToolInfo) then
            for hotKey, toolInfo in pairs(hotkeyToToolInfo) do
                Slab.Text(hotKey)
                Slab.SameLine()

                if Slab.BeginComboBox("hk tool chooser", {Selected = toolInfo.name}) then
                    for name,tinfo in pairs(nameToToolInfo) do
                        if Slab.TextSelectable(name) then
                            we.defineHotKey(hotKey, tinfo)
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
    local nameToToolInfo = we.getNameToToolInfoMap()

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





function worldeditUI.render()
    assert(we, "need to call init")
    if _G.settings.editing then
        Slab.BeginWindow("worldedit main win", {Title = "worldeditor"})

        do -- render current tool
        local tinfo = we.getCurrentToolInfo()
        local tname = tinfo and tinfo.name or "none"
        Slab.Text("Current tool: " .. tname, {Color = {0.7,0.7,1}})
        Slab.Text(" ")
        end

        renderToolDropDown()
        Slab.Text(" ")
        renderHotkeyDropDown()

        Slab.EndWindow()

        if currentToolInfoEditing then
            renderToolEditor()
        end
    end
end



return worldeditUI

