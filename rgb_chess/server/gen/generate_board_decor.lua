

local PINE_STEP = 45
local PINE_RANDOM = 15

local GRASS_STEP = 13
local GRASS_RANDOM = 6
local GRASS_SPAWN_CHANCE = 0.2

local LIGHT_RANDOM = 80


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

    -- Pines:
    for xx = x, x + w, PINE_STEP do
        local dx,dy = getRandXY(PINE_RANDOM)
        server.entities.pine(xx + dx, y + dy)
    end
    for yy = y, y + h, PINE_STEP do
        local dx,dy = getRandXY(PINE_RANDOM)
        server.entities.pine(x + dx, yy + dy)
        server.entities.pine(x - dx + w, yy - dy)
    end

    -- Grass:
    for xx = x + 20, x + w - 20, GRASS_STEP do
        for yy = y + 50, y + h - 160, GRASS_STEP do
            if math.random() < GRASS_SPAWN_CHANCE then
                local dx, dy = getRandXY(GRASS_RANDOM)
                server.entities.grass(xx + dx, yy + dy)
            end
        end
    end

    -- Lights:
    for xi=1, 2 do
        for yi=1, 2 do
            local lx = x + (xi * w/2) - w/4
            local ly = y + (yi * h/2) - h/4
            local rx, ry = (math.random()-0.5) * LIGHT_RANDOM, (math.random()-0.5) * LIGHT_RANDOM
            server.entities.light(lx+rx, ly+ry, 200)
        end
    end
    local lx, ly = x + w/2, y + h/2
    local rx, ry = (math.random()-0.5) * LIGHT_RANDOM, (math.random()-0.5) * LIGHT_RANDOM
    server.entities.light(lx+rx, ly+ry, 200)
end

return generateBoardDecor

