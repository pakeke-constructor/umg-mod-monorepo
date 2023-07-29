

--[[

allows us to manually make calls to animate entities.


]]


local drawEntities = require("client.draw_entities")
local getDrawY = drawEntities.getDrawY


local drawImage = require("client.helper.draw_image")



local drawIndexToAnimObj = {} -- [draw_index] -> anim_object


local entToAnimObj = {} -- [ent] -> anim_object
local entAnimations = {} -- list of animation objects



local WHITE = {1,1,1}


-- the current time.
local curTime = love.timer.getTime()


local function animate(frames, time, x,y,z, color)
    local obj = {
        frames = frames;
        startTime = curTime;
        time = time;
        x = x,
        y = y,
        z = z or 0,
        color = color or WHITE,
    }

    local indx = math.floor(getDrawY(obj.y, obj.z))
    drawIndexToAnimObj[indx] = drawIndexToAnimObj[indx] or {}
    table.insert(drawIndexToAnimObj[indx], obj)
end






local function animateEntity(ent, frames, time)
    if entToAnimObj[ent] then
        return false -- can't have 2 animations at once
    end
    
    local obj = {
        ent = ent,
        frames = frames,
        time = time,
        old_image = ent.image,
        startTime = curTime
    }

    entToAnimObj[ent] = obj
    table.insert(entAnimations, obj)
    return true
end



local function isFinished(animObj)
    return curTime >= (animObj.startTime + animObj.time)
end






umg.on("@update", function(dt)
    curTime = state.getGameTime()
end)



local ANIMATION_PRIORITY = 5

umg.answer("rendering:getImage", function(ent)
    local obj = entToAnimObj[ent]
    if obj then
        local i = math.floor(((curTime - obj.startTime) / obj.time) * (#obj.frames)) + 1
        local imgName = obj.frames[i]
        return imgName, ANIMATION_PRIORITY
    end
end)



umg.on("@update", function()
    --[[
        remove animation objects that are completed.
    ]]
    for i=#entAnimations,1,-1 do
        local obj = entAnimations[i]
        if isFinished(obj) then
            -- remove from array
            local arr = entAnimations
            arr[i] = arr[#arr]
            arr[#arr] = nil
            obj.ent.image = obj.old_image
            entToAnimObj[obj.ent] = nil
        end
    end
end)



















--[[

regular animations objects:

]]

local function drawAnimObj(animObj)
    local add_x = 0
    local add_y = 0
    local add_z = 0

    if animObj.follow_ent then
        local ent = animObj.follow_ent
        if umg.exists(ent) then
            add_x = ent.x or animObj.add_x
            add_y = ent.y or animObj.add_y
            add_z = ent.z or animObj.add_z or 0
            animObj.add_x = add_x
            animObj.add_y = add_y
            animObj.add_z = add_z
        end
    end
    local i = math.floor(((curTime - animObj.startTime) / animObj.time) * (#animObj.frames)) + 1
    local quadName = animObj.frames[i]
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(animObj.color)
    local y = getDrawY(add_y, add_z) + getDrawY(animObj.y, animObj.z)
    drawImage(quadName, animObj.x + add_x, y)
    love.graphics.setColor(r,g,b,a)
end




umg.on("rendering:drawIndex", function(indx)
    if drawIndexToAnimObj[indx] then
        local arr = drawIndexToAnimObj[indx]
        local len = #arr
        for i=len, 1, -1 do
            local animObj = arr[i]
            if isFinished(animObj) then
                -- remove from array
                arr[i] = arr[#arr]
                arr[#arr] = nil
            else
                drawAnimObj(animObj)
            end
        end

        if #arr == 0 then
            drawIndexToAnimObj[indx] = nil
        end
    end
end)


return {
    animate = animate,
    animateEntity = animateEntity
}

