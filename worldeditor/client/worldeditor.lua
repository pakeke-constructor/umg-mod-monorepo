

local worldeditUI = require("client.worldeditor_ui")

local constants = require("shared.constants")



--  API that's used by the UI.
-- THIS IS ONLY USED INTERNALLY!
local we = {}
setmetatable(we, {__index = error})




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


local hotkeyList = base.Array()
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
    if not toolInfo.serverUpdated then
        toolInfo.serverUpdated = true
        we.syncTool(toolInfo)
    end
end



umg.on("postDrawWorld", function()
    if _G.settings.editing then
        love.graphics.push("all")
        love.graphics.setLineWidth(3)
        local currentTool = we.getCurrentToolInfo()
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

umg.on("slabUpdate", function()
    worldeditUI.render()
end)

