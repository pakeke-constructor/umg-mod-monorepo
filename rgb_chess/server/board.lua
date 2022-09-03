

local BOARD_WIDTH = 700
local BOARD_HEIGHT = 700

local CARD_SPACING = 80
local CARD_EXTRA_X = 100


local Board = base.Class("rgb_chess:board")

local usernameToBoard = {
--[[
    [username] = Board

    Note that `username` is also the value of the `.rgbTeam` component
    for all the entities owned by that user.
]]
}




-- Static method:
function Board.getBoard(username_or_team)
    return usernameToBoard[username_or_team]
end


function Board.iterBoards()
    return pairs(usernameToBoard)
end




function Board:init(x, y, owner)
    self.x = x
    self.y = y

    self.width = BOARD_WIDTH
    self.height = BOARD_HEIGHT

    self.money = 0

    self.shopSize = 5
    self.shop = {--[[card1, card2, ... ]]}
    self.shopLocks = {--[[
        [shopIndex] = true/false
        tells what shop items are locked
    ]]}

    self.owner = owner
    self.rgbTeam = owner

    self.units = {--[[
        ent1, ent2, ...
    ]]}

    -- Only used during battle.
    self.enemies = {--[[
        enemy1, enemy2, enemy3
    ]]}

    self.turn = 0

    usernameToBoard[owner] = self
end

function Board:getMoney()
    return self.money
end

function Board:setMoney(x)
    server.broadcast("setMoney", self:getTeam(), x)
    self.money = x
end

function Board:getXY()
    return self.x, self.y
end

function Board:getCardXY(i)
    local x1 = self.x + self.width/2
    local dx = ((i - 1) - (self.shopSize/2)) * CARD_SPACING
    return CARD_EXTRA_X + x1 + dx, self.y + (self.height * (5/6))
end

function Board:getRerollButtonXY()
    return self.x + (self.width * (1/6)), self.y + (self.height * (5/6))
end

function Board:getMoneyTextXY()
    return self.x + (self.width * (1/6)), self.y + (self.height * (11/12))
end

function Board:getBattleButtonXY()
    return self.x + (self.width * (1/6)), self.y + (self.height)
end
    
function Board:getWH()
    return self.width, self.height
end

function Board:getOwner()
    return self.owner
end

function Board:getTeam()
    return self.owner
end

function Board:getTurn()
    return self.turn
end


function Board:delete()
    self:clear()
    usernameToBoard[self.owner] = nil
end


function Board:iterUnits()
    return categories.getSet(self:getTeam()):ipairs()
end

function Board:addUnit(unit_ent)
    table.insert(self.units, unit_ent)
end




function Board:serialize()
    -- serializes the allies on the board
    local buffer = {}
    for _, ent in rgb.ipairs(self:getTeam()) do
        table.insert(buffer, ent)
    end
    self.serialized = serialize(buffer)
end

function Board:deserializeAllies()
    if self.serialized then
        local arr, err = deserialize(self.serialized)
        if (not arr) and err then
            print("[rgb_chess]: error in deserializing allies for board: ", err)
        end
        return arr
    else
        return {}
    end
end




function Board:clear()
    local enemyTeam = self.enemyRgbTeam
    if enemyTeam then
        for _, ent in rgb.ipairs(enemyTeam) do
            ent:delete()
        end
    end
    for _, ent in rgb.ipairs(self:getTeam()) do
        ent:delete()
    end
end


function Board:reset()
    --[[
        resets board state and deserializes allies.
    ]]
    self.winner = nil
    self.enemyTeam = nil

    local arr = self:deserializeAllies()
    for i=1, #arr do
        rgb.setTeam(arr[i], self:getTeam())
    end
end




local function rand(middle, ampli)
    return middle + (math.random()-.5) * ampli * 2
end


function Board:putEnemies(enemyArray)
    --[[
        puts enemies on the board
        TODO: Make particle effects and stuff here
        Enemy units top of board, Allied units start bottom.
    ]]
    local x, y = self:getXY()
    local w, h = self:getWH()
    local team = self:getTeam()
    assert(self.enemyRgbTeam, "enemy team id must be set.")

    for _, ent in ipairs(enemyArray) do
        rgb.setTeam(ent, self.enemyRgbTeam)
        rgb.setTarget(ent, team)
        if rgb.isRanged(ent) then
            -- put ranged units at the back
            ent.x = rand(x + w/2, w/3)
            ent.y = rand(y + h/6, h/20)
        else
            -- and melee units at the front
            ent.x = rand(x + w/2, w/3)
            ent.y = rand(y + h/3, h/20)
        end
    end
end


function Board:putAllies(allyArray)
    --[[
        puts allies on the board
        TODO: Make particle effects and stuff here
        Enemy units top of board, Allied units start bottom.
    ]]
    local x, y = self:getXY()
    local w, h = self:getWH()
    assert(self.enemyRgbTeam, "enemy team id must be set.")

    for _, ent in ipairs(allyArray) do
        rgb.setTarget(ent, self.enemyRgbTeam)
        if rgb.isRanged(ent) then
            -- put ranged units at the back
            ent.x = rand(x + w/2, w/3)
            ent.y = rand(y + h*5/6, h/20)
        else
            -- and melee units at the front
            ent.x = rand(x + w/2, w/3)
            ent.y = rand(y + h*2/3, h/20)
        end
    end
end


function Board:setEnemyTeam(enemyRgbTeam)
    self.enemyRgbTeam = enemyRgbTeam
end

function Board:isBattleOver()
    local self_category = self.rgbTeam
    local enemy_category = self.enemyRgbTeam
    if enemy_category then
        local enemies = categories.getSet(enemy_category)
        local allies = categories.getSet(self_category)
        if enemies.size == 0 then
            self.winner = self:getTeam()
            return true
        end
        if allies.size == 0 then
            self.winner = enemy_category
            return true
        end
    else
        return true -- this board isn't having a fight.
    end
end


function Board:getWinner()
    return self.winner
end



return Board

