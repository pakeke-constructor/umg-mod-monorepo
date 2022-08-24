
local draw = require("client.draw")

local drawImage = require("client.image_helpers.draw_image")



local drawIndexToAnimObj = {}


local WHITE = {1,1,1}


local function animate(frames, time, x,y,z, cycles, color, follow_ent, hide_ent)
    local obj = {
        frames = frames;
        startTime = timer.getTime();
        time = time;
        x = x,
        y = y,
        z = z or 0,
        cycles = cycles or 1,
        color = color or WHITE,
        follow_ent = follow_ent,
        hide_ent = hide_ent
    }

    local indx = math.floor(draw.getScreenY(obj))
    if exists(follow_ent) then
        indx = math.floor(draw.getScreenY(follow_ent))
    else
        indx = math.floor(draw.getScreenY(obj))
    end
    drawIndexToAnimObj[indx] = drawIndexToAnimObj[indx] or {}
    table.insert(drawIndexToAnimObj[indx], obj)
end




local curTime = timer.getTime()


on("update", function(dt)
    curTime = timer.getTime()
end)





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


on("drawIndex", function(indx)
    if drawIndexToAnimObj[indx] then
        local arr = drawIndexToAnimObj[indx]
        local len = #arr
        for i=len, 1, -1 do
            local animObj = arr[i]
            if isFinished(animObj) then
                -- remove from array
                arr[i], arr[#arr] = arr[#arr], nil
            else
                drawAnimObj(animObj)
            end
        end

        if #arr == 0 then
            drawIndexToAnimObj[indx] = nil
        end
    end
end)


return animate

