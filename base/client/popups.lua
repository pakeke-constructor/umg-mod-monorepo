
local typecheck = require("shared.typecheck")
local Color = require("client.color")
local getGameTime = require("shared.get_game_time")

local Heap = require("shared.heap")


local function endTimeComparator(a,b)
    return a.endTime < b.endTime
end



local DEFAULT_POPUP_DURATION = 0.5
local DEFAULT_FADE_TIME = 0.1


local popups = {}


local imageHeap = Heap(endTimeComparator)

function popups.image(image, x, y, options)
    --[[
        draw a popup image for a short period of time
    ]]
    local obj = {}
    obj.color = options.color or Color.WHITE
    obj.fade = options.fade or DEFAULT_FADE_TIME
    obj.duration = options.duration or DEFAULT_POPUP_DURATION
    obj.rotation = options.rotation or 0
    obj.rotationSpeed = options.rotationSpeed or 0
    obj.scale = options.scale or 1
    obj.scaleX = options.scaleX or 1
    obj.scaleY = options.scaleY or 1

    obj.image = image
    obj.x, obj.y = x, y

    obj.endTime = obj.duration + getGameTime()
    imageHeap:insert(obj)
end




local DEFAULT_BACKDROP_DISTANCE = 1
local DEFAULT_BACKDROP_COLOR_SHIFT = -0.5


local textHeap = Heap(endTimeComparator)


local textTc = typecheck.assert("string", "number", "number", "table?")

function popups.text(text, x, y, options)
    --[[
        draw popup text for a short period of time
    ]]
    textTc(text, x, y, options)
    
    local obj = {}
    obj.color = options.color or Color.WHITE
    obj.fade = options.fade or DEFAULT_FADE_TIME
    obj.duration = options.duration or DEFAULT_POPUP_DURATION
    obj.backdropDistance = options.backdropDistance or DEFAULT_BACKDROP_DISTANCE 
    obj.backdropColorShift = options.backdropColorShift or DEFAULT_BACKDROP_COLOR_SHIFT
    obj.rotation = options.rotation or 0
    obj.rotationSpeed = options.rotationSpeed or 0
    obj.scale = options.scale or 1
    obj.scaleX = options.scaleX or 1
    obj.scaleY = options.scaleY or 1

    obj.text = text
    obj.x, obj.y = x, y

    obj.startTime = getGameTime()
    obj.endTime = obj.duration + obj.startTime
    textHeap:insert(obj)
end




function popups.animation(frames, x, y, color)
    --[[
        TODO: Currently, client.animate has this functionality.
        We should look to move the client.animate() function out of that
        file, and put it in here instead.
        Alternatively, we could simply call `.animate()` from this file.

        Have a think.
    ]]
end




local function drawTextObj(textObj)
    local time = getGameTime()
    local rot = textObj.rotation + (time - textObj.startTime) * textObj.rotationSpeed
    local sx, sy = textObj.scale * textObj.scaleX, textObj.scale * textObj.scaleY
    local font = love.graphics.getFont()
    local ox, oy = font:getWidth()/2, font:getHeight()/2

    if textObj.backdropDistance > 0 then
        local c = textObj.color
        local s = textObj.backdropColorShift
        local bdd = textObj.backdropDistance
        love.graphics.setColor(c.r-s, c.g-s, c.b-s)
        love.graphics.print(textObj.text, textObj.x-bdd, textObj.y-bdd, rot, sx, sy, ox,oy)
    end
    
    love.graphics.setColor(textObj.color)
    love.graphics.print(textObj.text, textObj.x, textObj.y, rot, sx, sy, ox,oy)
end


local function drawImageObj(imageObj)

end



umg.on("drawEffects", function()
    for _, textObj in ipairs(textHeap) do
        drawTextObj(textObj)
    end

    for _, imageObj in ipairs(imageHeap) do
        drawImageObj(imageObj)
    end
end)




return popups
