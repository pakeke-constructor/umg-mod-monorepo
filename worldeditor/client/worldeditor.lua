

local worldeditUI = require("client.worldeditor_ui")

local constants = require("shared.constants")



--  API that's used by the UI.
-- THIS IS ONLY USED INTERNALLY!
local we = {}
setmetatable(we, {__index = error})





client.on("worldeditorSetMode", function(active)
    _G.settings.editing = active
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


local hotkeyList = objects.Array()
for hk, _ in pairs(validHotKeys) do
    hotkeyList:add(hk)
end
table.sort(hotkeyList)



--  keeps track of all the tools that currently exist.
local nameToToolInfo = {--[[
    [name] --> toolInfo
]]}


local hotkeyToToolInfo = {--[[
    [hotkey] --> toolInfo
]]}


local currentHotKey = "1"



function we.getHotkeys()
    return hotkeyList
end

function we.getNameToToolInfoMap()
    return nameToToolInfo
end

function we.getHotkeyToToolInfoMap()
    return hotkeyToToolInfo
end


function we.syncTool(toolInfo)
    client.send("worldeditorDefineTool", toolInfo.tool, toolInfo.name)
end


function we.getCurrentToolInfo()
    return hotkeyToToolInfo[currentHotKey or ""]
end


function we.defineHotKey(hotkey, toolInfo)
    hotkeyToToolInfo[hotkey] = toolInfo
end

function we.deleteHotKey(hotkey)
    hotkeyToToolInfo[hotkey] = nil
end


function we.defineNewToolInfo(toolInfo)
    assert(toolInfo:allReady(), "?")
    nameToToolInfo[toolInfo.name] = toolInfo
end


function we.deleteToolInfo(toolInfo)
    if toolInfo.name then
        nameToToolInfo[toolInfo.name] = nil
    end
    for hk, tinfo in pairs(hotkeyToToolInfo)do
        -- if the tool info is being used by a hotkey, delete it.
        if tinfo == toolInfo then
            we.deleteHotKey(hk)
        end
    end
end


local function ensureServerKnowsTool(toolInfo)
    if not toolInfo:isSynced() then
        toolInfo:setIsSynced(true)
        we.syncTool(toolInfo)
    end
end



local PRIO = -150

umg.on("rendering:drawWorld", function()
    if _G.settings.editing then
        love.graphics.push("all")
        love.graphics.setLineWidth(3)
        local tinfo = we.getCurrentToolInfo()
        if tinfo and tinfo.tool and tinfo.tool.draw then
            local tool = tinfo.tool
            local x, y = rendering.getWorldMousePosition()
            tool:draw(x,y)
        end
        love.graphics.pop()
    end
end, PRIO)




local listener = input.Listener({priority = 1})


local CAMERA_SPEED = 800

local camera_x, camera_y = 0, 0

-- worldedit camera should have a pretty high priority:
local WORLDEDIT_CAMERA_PRIORITY = 100


umg.answer("rendering:getCameraPosition", function()
    if _G.settings.editing then
        return camera_x, camera_y, WORLDEDIT_CAMERA_PRIORITY
    end
    return nil -- let another system take over
end)


local function updateCameraPosition(dt)
    local dx = 0
    local dy = 0
    local camera = rendering.getCamera()
    local delta = CAMERA_SPEED * dt / camera.scale

    if listener:isControlDown(input.UP) then
        dy = dy - delta
    end
    if listener:isControlDown(input.DOWN) then
        dy = dy + delta
    end
    if listener:isControlDown(input.LEFT) then
        dx = dx - delta
    end
    if listener:isControlDown(input.RIGHT) then
        dx = dx + delta
    end

    local x,y = camera.x + dx, camera.y + dy

    camera_x, camera_y = x, y
end




local BUTTON_1 = 1


-- to ensure we only send one event across per tick
local DONE_THIS_TICK = false


umg.on("@tick", function()
    DONE_THIS_TICK = false
end)


local function applyTool(toolInfo)
    if (not DONE_THIS_TICK) then
        local worldX, worldY = rendering.getWorldMousePosition()
        ensureServerKnowsTool(toolInfo)
        client.send("worldeditorSetTool", toolInfo.name)
        client.send("worldeditorUseTool", toolInfo.name, worldX, worldY, BUTTON_1)
        DONE_THIS_TICK = true
    end
end




function listener:update(dt)
    if _G.settings.editing then
        updateCameraPosition(dt)
        local tinfo = we.getCurrentToolInfo()
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
        local tinfo = we.getCurrentToolInfo()
        if tinfo and tinfo.tool.useType == constants.USE_TYPE.DISCRETE then
            applyTool(tinfo)
        end
    end
end


worldeditUI.init(we)

umg.on("ui:slabUpdate", function()
    worldeditUI.render()
end)

