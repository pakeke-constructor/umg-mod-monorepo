
local typecheck = require("shared.typecheck")
local Color = require("client.color")
local getGameTime = require("shared.get_game_time")

local Heap = require("shared.heap")


local function endTimeComparator(a,b)
    return a.endTime < b.endTime
end



local DEFAULT_POPUP_DURATION = 0.5
local DEFAULT_FADE_TIME = 0.1
local DEFAULT_BACKDROP_DISTANCE = 1


local popups = {}



function popups.image(image, x, y, options)
    --[[
        draw a popup image for a short period of time
    ]]
end



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

    obj.text = text
    obj.x, obj.y = x, y

    obj.endTime = obj.duration + getGameTime()
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







return popups
