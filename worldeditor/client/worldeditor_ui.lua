

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

local currentImportState


local function openToolEditor(toolInfo)
    currentToolInfoEditing = toolInfo
end

local function closeToolEditor()
    currentToolInfoEditing = nil
end



local function openImporter()
    currentImportState = {
        text = "",
        error = nil
    }
end

local function closeImporter()
    currentImportState = nil
end



local buttonApplyColor = {0.2,0.8,0.3}
local nameColor = {0.8,0.8,0.2}
local typeColor = {0.1,0.9,0.9}
local buttonCancelColor = {0.8,0.25,0.25}
local buttonOtherColor = {0.65,0.65,0.2}
local buttonEditColor = {0.21,0.21,0.9}



-- this function assumes that the package is valid
local function importPackage(package)
    if package.type == HOTKEYS then
        -- package.object is a hotkey map
        for hk, tinfo in pairs(package.object) do
            tinfo:setIsSynced(false)
            we.defineNewToolInfo(tinfo)
            we.defineHotKey(hk, tinfo)
        end
    elseif package.type == TOOL then
        local tinfo = package.object
        tinfo:setIsSynced(false)
        we.defineNewToolInfo(tinfo)
    end
end



local function renderImportWindow()
    Slab.BeginWindow("import window", {Title = "Importer"})
    local istate = currentImportState
    Slab.Text(" ")
    if Slab.Button("Import from Clipboard", {Color = buttonEditColor, H = 40}) then
        istate.text = love.system.getClipboardText()
    end
    Slab.Text("Import: ")
    local shortenedText = istate.text:sub(1, math.min(istate.text:len(), 30))
    Slab.Text(shortenedText, {Color = buttonEditColor})
    Slab.Text(" ")
    if Slab.Button("Apply", {Color = buttonOtherColor}) then
        local package
        package, istate.error = sharing.import(istate.text)
        if package and package.object and package.type then
            importPackage(package)
        end
    end
    if istate.error then
        Slab.Text("Error on import: ")
        Slab.Text(tostring(istate.error), {Color = buttonCancelColor})
    end
    Slab.Text("  ")
    local closePrompt = istate.result and "Done" or "Cancel"
    if Slab.Button(closePrompt, {Color = buttonCancelColor}) then
        closeImporter()
    end

    Slab.Text(" ")
    Slab.EndWindow()
end





local EXPORT_HOVER_TIME = 5 -- seconds to hover export message

local renderExportTC = typecheck.assert("string", "string", "table", "number")
-- eg:  lastExportTime = renderExportUI( "tool", lastExportTime, toolInfo.name, toolInfo )
local function renderExportUI(packageType, exportName, exportObject, lastExportTime)
    renderExportTC(packageType, exportName, exportObject, lastExportTime)
    assert(sharing.packageTypes[packageType], "?")
    if Slab.Button("Export " .. packageType, {Color = buttonOtherColor}) then
        sharing.exportToClipboard(exportName, exportObject, packageType)
        lastExportTime = love.timer.getTime()
    end
    if lastExportTime+EXPORT_HOVER_TIME > love.timer.getTime() then
        Slab.Text("Exported to clipboard!")
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
        if next(hotkeyToToolInfo) then
            lastExportTime = renderExportUI(HOTKEYS, "Hotkeys", we.getHotkeyToToolInfoMap(), lastExportTime)
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

        if Slab.Button("import", {Color = buttonEditColor}) then
            openImporter()
        end
        Slab.Text(" ")

        renderToolDropDown()
        Slab.Text(" ")
        renderHotkeyDropDown()

        Slab.EndWindow()

        if currentToolInfoEditing then
            renderToolEditor()
        end

        if currentImportState then
            renderImportWindow()
        end
    end
end



return worldeditUI

