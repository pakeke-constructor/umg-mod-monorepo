


local rain = {}



local rainDrops = objects.Array()


--[[
    OPTIONS:
]]
local rainDrift = 0
-- How much the rain drifts in the X direction, per unit of Y.

local rainColor = {202/255, 204/255, 240/255, 0.89}
-- Rain color


-- Good rate is 200.
local rainRate = 0
-- How many raindrops fall per second, per 1000 pixels

local rainSpeed = 800
-- The speed the rain falls

-- size of rain tail
local minTailSize = 20
local maxTailSize = 24



local function newRainDrop()
    local x1, y1 = rendering.toWorldCoords(0,0)
    local x2, y2 = rendering.toWorldCoords(love.graphics.getDimensions())
    local w,  h  = x2-x1, y2-y1

    local rainDrop = {
        -- starting x,y position
        x = x1 + math.random()*2*w - w/2,
        y = y1 - math.random()*h,

        tailSize = minTailSize + math.random()*(maxTailSize-minTailSize),
        
        stopY = y1 + math.random()*h*(1.25) -- the y position this rainDrop will stop at
    }
    rainDrops:add(rainDrop)
end



local function drawRainDrop(rainDrop)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(rainColor)
    local x,y = rainDrop.x, rainDrop.y
    local newY = math.min(rainDrop.stopY, rainDrop.y + rainDrop.tailSize)
    local dy = math.abs(newY - y)
    local newX = x + rainDrift*dy
    love.graphics.line(x,y, newX,newY)
end


local function updateRainDrop(rainDrop, dt)
    local dy = rainSpeed * dt
    local dx = dy * rainDrift
    rainDrop.y = rainDrop.y + dy
    rainDrop.x = rainDrop.x + dx
end


local frames = {}
for i=1,5 do
    table.insert(frames, "raindrop_" .. tostring(i))
end



local function killRainDrop(rainDrop)
    --[[
        TODO: Make particles here,
        perhaps play a "splash" sound?
    ]]
    rendering.animate(frames, 0.3, rainDrop.x, rainDrop.y, 0, rainColor)
end


local function spawnRainDrops(dt)
    local x1 = rendering.toWorldCoords(0,0)
    local x2 = rendering.toWorldCoords(love.graphics.getWidth(),0)
    local cameraSpan = x2 - x1

    local numDrops = rainRate * dt * (cameraSpan/1000)
    while math.random() < numDrops do
        numDrops = numDrops - 1
        newRainDrop()
    end
end



umg.on("state:gameUpdate", function(dt)
    for i=#rainDrops, 1, -1 do
        local rd = rainDrops[i]
        if rd then
            updateRainDrop(rd, dt)
            if rd.y > rd.stopY then
                killRainDrop(rd)
                rainDrops:quickPop(i)
            end
        end
    end

    spawnRainDrops(dt)
end)



umg.on("drawEffects", function()
    for _,rd in ipairs(rainDrops) do
        drawRainDrop(rd)
    end
end)



function rain.setOptions(options)
    rainColor = options.rainColor or rainColor
    rainDrift = options.rainDrift or rainDrift
    rainRate = options.rainRate or rainRate
    rainSpeed = options.rainSpeed or rainSpeed
    minTailSize = options.minTailSize or minTailSize
    maxTailSize = options.maxTailSize or maxTailSize
end

function rain.getOptions()
    return {
        rainColor = rainColor,
        rainDrift = rainDrift,
        rainRate = rainRate,
        rainSpeed = rainSpeed,
        minTailSize = minTailSize,
        maxTailSize = maxTailSize
    }
end


return rain
