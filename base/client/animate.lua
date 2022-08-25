
local draw = require("client.draw")

local drawImage = require("client.image_helpers.draw_image")



local drawIndexToAnimObj = {}

local entAnimations = {}



local WHITE = {1,1,1}


-- the current time.
local curTime = timer.getTime()


local function animate(frames, time, x,y,z, color)
    local obj = {
        frames = frames;
        startTime = timer.getTime();
        time = time;
        x = x,
        y = y,
        z = z or 0,
        color = color or WHITE,
    }

    local indx = math.floor(draw.getScreenY(obj))
    drawIndexToAnimObj[indx] = drawIndexToAnimObj[indx] or {}
    table.insert(drawIndexToAnimObj[indx], obj)
end






local function animateEntity(ent, frames, time)
    local obj = {
        ent = ent,
        frames = frames,
        time = time,
        old_image = ent.image,
        startTime = timer.getTime()
    }

    table.insert(entAnimations, obj)
end



local function isFinished(animObj)
    return curTime >= (animObj.startTime + animObj.time)
end




local function drawAnimObj(animObj)
    local add_x = 0
    local add_y = 0
    local add_z = 0

    if animObj.follow_ent then
        local ent = animObj.follow_ent
        if exists(ent) then
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
    local r,g,b,a = graphics.getColor()
    graphics.setColor(animObj.color)
    local y = draw.getScreenY(add_y, add_z) + draw.getScreenY(animObj)
    drawImage(quadName, animObj.x + add_x, y)
    graphics.setColor(r,g,b,a)
end



local function updateEntAnimationObject(obj)
    local i = math.floor(((curTime - obj.startTime) / obj.time) * (#obj.frames)) + 1
    local quadName = obj.frames[i]
    obj.ent.image = quadName
end



on("update", function(dt)
    curTime = timer.getTime()
end)




on("preDraw", function()
    --[[
    Updates entity animations from `animateEntity(...)`

    we aren't actually drawing anything here, we are updating stuff.
    The reason we are updating here is so it doesn't get overridden by 
    other systems;  like moveAnimation component or animation component.
    
    If we update directly before drawing, nothing can override it.
    ]]
    for i=#entAnimations,1,-1 do
        local obj = entAnimations[i]
        if isFinished(obj) then
            -- remove from array
            local arr = entAnimations
            arr[i] = arr[#arr]
            arr[#arr] = nil
            obj.ent.image = obj.old_image
        else
            updateEntAnimationObject(obj)
        end
    end
end)




on("drawIndex", function(indx)
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

