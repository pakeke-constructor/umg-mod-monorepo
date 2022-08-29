

local PINE_STEP = 45
local PINE_RANDOM = 15

local GRASS_STEP = 13
local GRASS_RANDOM = 6
local GRASS_SPAWN_CHANCE = 0.2

--[[


(x,y) ---------------
  |                 | pines
  |      board      | along
  |                 | sides
  |                 |
  |      cards      |
  -------------------


]]

local function getRandXY(mag)
    local dx = math.floor((math.random()-0.5) * mag * 2)
    local dy = math.floor((math.random()-0.5) * mag * 2)
    return dx, dy
end


local function generateBoardDecor(board)
    local x, y = board:getXY()
    local w, h = board:getWH()

    for xx = x, x + w, PINE_STEP do
        local dx,dy = getRandXY(PINE_RANDOM)
        entities.pine(xx + dx, y + dy)
    end

    for yy = y, y + h, PINE_STEP do
        local dx,dy = getRandXY(PINE_RANDOM)
        entities.pine(x + dx, yy + dy)
        entities.pine(x - dx + w, yy - dy)
    end

    for xx = x + PINE_RANDOM, x + w - PINE_RANDOM, GRASS_STEP do
        for yy = y + PINE_RANDOM, y + h - PINE_RANDOM, GRASS_STEP do
            if math.random() < GRASS_SPAWN_CHANCE then
                local dx, dy = getRandXY(GRASS_RANDOM)
                entities.grass(xx + dx, yy + dy)
            end
        end
    end
end

return generateBoardDecor

