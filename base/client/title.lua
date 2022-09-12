
local Heap = require("other.heap")



local DEFAULT_TITLE_TIME = 3
local DEFAULT_FADE_TIME = 0.4

local WHITE = {1,1,1}

local DEFAULT_X = 1/2 -- halfway across screen
local DEFAULT_Y = 1/2 -- halfway down screen


local INTERNAL_TEXT_SCALE = 1
local DEFAULT_SCALE = 1

local BACKDROP_COLOR_SHIFT = 0.6


local function compare(a,b)
    return a.endTime > b.endTime
end


local titleObjs = Heap(compare)



on("update",function()
    local t = timer.getTime()
    local obj = titleObjs:peek()
    while obj and obj.endTime <= t do
        titleObjs:pop()
        obj = titleObjs:peek()
    end
end)




local function drawTitle(obj, time)
    graphics.push("all")
    local w,h = graphics.getWidth(), graphics.getHeight()
    local scale = base.getUIScale()
    local drawX, drawY = obj.x * w / scale, obj.y * h / scale
    local txtScale = obj.scale * INTERNAL_TEXT_SCALE
    local font = graphics.getFont()
    local txtH = font:getHeight(obj.text)
    local txtW = font:getWidth(obj.text)

    local c = obj.color
    local fadeVal = math.max(0, (obj.endTime - time) / obj.fade)
    local bcs = BACKDROP_COLOR_SHIFT
    graphics.setColor(c[1]-bcs,c[2]-bcs,c[3]-bcs,fadeVal)
    graphics.print(obj.text, drawX-1, drawY-1, obj.rot or 0, txtScale, txtScale, txtW/2, txtH/2)
    
    graphics.setColor(c[1],c[2],c[3],fadeVal)
    graphics.print(obj.text, drawX, drawY, obj.rot or 0, txtScale, txtScale, txtW/2, txtH/2)
    graphics.pop()
end



on("mainDrawUI", function()
    local time = timer.getTime()
    for i=1, #titleObjs do
        local obj = titleObjs[i]
        drawTitle(obj, time)
    end
end)



local function title(text, options)
    --[[
        title("hello", {
            time = 3, -- displays for X seconds
            fade = 1, -- fades out in X seconds
            color = {1,0,0},
            x = 1/2, -- X and Y location is in middle of screen. 
            y = 1/2,

        })
    ]]
    assert(type(text) == "string", "title(text, options) requires a string as first arg")
    local obj = options or {}

    obj.endTime = timer.getTime() + (obj.time or DEFAULT_TITLE_TIME)
    obj.fade = obj.fade or DEFAULT_FADE_TIME
    obj.color = obj.color or WHITE
    obj.x = obj.x or DEFAULT_X
    obj.y = obj.y or DEFAULT_Y
    obj.text = text
    obj.scale = obj.scale or DEFAULT_SCALE

    titleObjs:insert(obj)
end



return title

