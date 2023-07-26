

local getGameTime = state.getGameTime



local function endTimeComparator(a,b)
    return a.endTime < b.endTime
end



local DEFAULT_POPUP_DURATION = 0.5
local DEFAULT_FADE_TIME = 0.1


local popups = {}


local imageHeap = objects.Heap(endTimeComparator)


local imageTc = typecheck.assert("string", "number", "number", "table?")

function popups.image(image, x, y, options)
    --[[
        draw a popup image for a short period of time
    ]]
    imageTc(image, x, y, options)

    local obj = {}
    options = options or {}
    obj.color = options.color or objects.Color.WHITE
    obj.fade = options.fade or DEFAULT_FADE_TIME
    obj.duration = options.duration or DEFAULT_POPUP_DURATION
    obj.rotation = options.rotation or 0
    obj.rotationSpeed = options.rotationSpeed or 0
    obj.scale = options.scale or 1
    obj.scaleX = options.scaleX or 1
    obj.scaleY = options.scaleY or 1
    
    obj.vx, obj.vy = options.vx or 0, options.vy or 0

    obj.image = image
    obj.x, obj.y = x, y

    obj.endTime = obj.duration + getGameTime()
    imageHeap:insert(obj)
end




local DEFAULT_BACKDROP_DISTANCE = 1
local DEFAULT_BACKDROP_COLOR_SHIFT = -0.8


local textHeap = objects.Heap(endTimeComparator)


local textTc = typecheck.assert("string", "number", "number", "table?")

function popups.text(text, x, y, options)
    --[[
        draw popup text for a short period of time

        List of options is shown below.
    ]]
    textTc(text, x, y, options)
    
    local obj = {}
    options = options or {}
    obj.color = options.color or objects.Color.WHITE
    obj.fadeTime = options.fadeTime or DEFAULT_FADE_TIME
    obj.duration = options.duration or DEFAULT_POPUP_DURATION

    obj.backdropDistance = options.backdropDistance or DEFAULT_BACKDROP_DISTANCE 
    obj.backdropColorShift = options.backdropColorShift or DEFAULT_BACKDROP_COLOR_SHIFT
    obj.backdropColor = options.backdropColor or nil

    obj.outline = options.outline
    obj.outlineColor = options.outlineColor or objects.Color.BLACK

    obj.rotation = options.rotation or 0
    obj.rotationSpeed = options.rotationSpeed or 0
    obj.scale = options.scale or 1
    obj.scaleX = options.scaleX or 1
    obj.scaleY = options.scaleY or 1

    obj.vx, obj.vy = options.vx or 0, options.vy or 0

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
    error("NYI")
end




local function drawTextObj(textObj)
    local text = textObj.text
    local time = getGameTime()
    local timeElapsed = time - textObj.startTime
    local rot = textObj.rotation + timeElapsed * textObj.rotationSpeed
    local x = textObj.x + textObj.vx * timeElapsed
    local y = textObj.y + textObj.vy * timeElapsed
    local sx, sy = textObj.scale * textObj.scaleX, textObj.scale * textObj.scaleY
    local font = love.graphics.getFont()
    local ox, oy = font:getWidth(text)/2, font:getHeight(text)/2
    local a = math.min(1, (textObj.endTime - time) / textObj.fadeTime)

    -- Draw outline
    if textObj.outline then
        local c = textObj.outlineColor
        love.graphics.setColor(c.r, c.g, c.b, a)
        love.graphics.print(text, x-1, y-1, rot, sx, sy, ox,oy)
        love.graphics.print(text, x+1, y-1, rot, sx, sy, ox,oy)
        love.graphics.print(text, x+1, y+1, rot, sx, sy, ox,oy)
        love.graphics.print(text, x-1, y+1, rot, sx, sy, ox,oy)
    end

    -- Draw backdrop
    if textObj.backdropDistance > 0 then
        local c = textObj.color
        local bdd = textObj.backdropDistance
        if textObj.backdropColor then
            love.graphics.setColor(textObj.backdropColor)
        else
            local s = textObj.backdropColorShift
            love.graphics.setColor(c.r+s, c.g+s, c.b+s, a)
        end
        love.graphics.print(text, x-bdd, y-bdd, rot, sx, sy, ox,oy)
    end
 
    -- Draw regular text
    do
    local c = textObj.color
    love.graphics.setColor(c.r, c.g, c.b, a)
    love.graphics.print(text, x, y, rot, sx, sy, ox,oy)
    end
end



local function drawImageObj(imageObj)
    local time = getGameTime()
    local timeElapsed = time - imageObj.startTime
    local rot = imageObj.rotation + timeElapsed * imageObj.rotationSpeed
    local x = imageObj.x + imageObj.vx * timeElapsed
    local y = imageObj.y + imageObj.vy * timeElapsed
    local sx, sy = imageObj.scale * imageObj.scaleX, imageObj.scale * imageObj.scaleY
    local a = math.min(1, (imageObj.endTime - time) / imageObj.fadeTime)

    local col = imageObj.color
    love.graphics.setColor(col.r, col.g, col.b, a)
    rendering.drawImage(imageObj.image, x, y, rot, sx, sy) 
end





local function cleanHeap(heap)
    local time = getGameTime()
    local obj = heap:peek()
    while obj and obj.endTime < time do
        heap:pop()
        obj = heap:peek()
    end
end



umg.on("drawEffects", function()
    cleanHeap(textHeap)
    cleanHeap(imageHeap)

    for _, textObj in ipairs(textHeap) do
        drawTextObj(textObj)
    end

    for _, imageObj in ipairs(imageHeap) do
        drawImageObj(imageObj)
    end
end)




return popups
