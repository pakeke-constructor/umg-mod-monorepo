
require("shared.constants")

local genCards = require("server.gen.generate_cards")
local itemPool = require("server.engine.item_pool")


local abilities
umg.on("@load", function()
    abilities = require("shared.abilities.abilities")
end)




local BOARD_WIDTH = constants.BOARD_WIDTH
local BOARD_HEIGHT = constants.BOARD_HEIGHT

local CARD_SPACING = 80
local CARD_EXTRA_X = 100

local CARD_LOCK_Y_SPACING = constants.CARD_LOCK_Y_SPACING -- how far down card locks are



local Board = objects.Class("rgb_chess:board")

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
    self.shopLocks = {--[[ lock1, lock2, ... ]]}

    self.owner = owner
    self.rgbTeam = owner


    usernameToBoard[owner] = self
end

function Board:getMoney()
    return self.money
end


local setMoneyTc = typecheck.assert("table", "number")

function Board:setMoney(x)
    setMoneyTc(self,x)
    server.broadcast("setMoney", self:getTeam(), x)
    self.money = x
end

function Board:getXY()
    return self.x, self.y
end

function Board:getCardXY(shopIndex)
    local x1 = self.x + self.width/2
    local dx = ((shopIndex - 1) - (self.shopSize/2)) * CARD_SPACING
    return CARD_EXTRA_X + x1 + dx, self.y + (self.height * (5/6))
end

function Board:getCard(shopIndex)
    return self.shop[shopIndex]
end

function Board:setCard(shopIndex, card)
    self.shop[shopIndex] = card
end



local isLockedTc = typecheck.assert("table", "entity | number")

function Board:isLocked(card_or_shopIndex)
    -- returns true/false whether card is locked or not
    isLockedTc(self, card_or_shopIndex)
    local shopIndex
    if type(card_or_shopIndex) == "number" then
        shopIndex = card_or_shopIndex
    else
        shopIndex = card_or_shopIndex.shopIndex
    end

    local lockEnt = self:getLockEntity(shopIndex)
    return lockEnt.isLocked
end


function Board:getLockEntity(shopIndex)
    return self.shopLocks[shopIndex]
end

function Board:setLocked(shopIndex, bool)
    local lockEnt = self:getLockEntity(shopIndex)
    lockEnt.isLocked = bool
end




local function spawnRerollButton(self)
    local x,y = self.x + (self.width * (1/6)), self.y + (self.height * (5/6))
    server.entities.reroll_button(x, y, self:getTeam())
end

local function spawnSellButton(self)
    local x,y = self.x + (self.width * (1/3)), self.y + self.height
    server.entities.sell_button(x,y,self:getTeam())
end

local function spawnToggleDetailsButton(self)
    local x,y = self.x + (self.width * (1/2)), self.y + self.height
    server.entities.show_details_button(x,y,self:getTeam())
end

local function spawnMoneyText(self)
    local x, y = self.x + (self.width * (1/6)), self.y + (self.height * (11/12))
    server.entities.money_text(x, y, self:getTeam())
end

local function spawnBattleButton(self)
    local x,y = self.x + (self.width * (1/6)), self.y + (self.height)
    server.entities.readyup_button(x, y, self:getTeam())
end

local function spawnBorder(self)
    local cx, cy = self.x + self.width/2, self.y + self.height/2
    local ent = server.entities.empty()
    ent.border = border.Border({
        centerX = cx,
        centerY = cy,
        width = self.width + constants.BOARD_BORDER_LEIGHWAY,
        height = self.height + constants.BOARD_BORDER_LEIGHWAY
    })
end


local function spawnShopLocks(self)
    for shopIndex=1, self.shopSize do
        local x, y = self:getCardXY(shopIndex)
        
        local e = server.entities.card_lock({
            x = x,
            y = y + CARD_LOCK_Y_SPACING,
            rgbTeam = self:getTeam(),
            shopIndex = shopIndex
        })
        self.shopLocks[shopIndex] = e
    end
end


function Board:spawnObjects()
    spawnShopLocks(self)
    spawnRerollButton(self)
    spawnMoneyText(self)
    spawnBattleButton(self)
    spawnSellButton(self)
    spawnToggleDetailsButton(self)
    spawnBorder(self)
end


function Board:getWH()
    return self.width, self.height
end

function Board:getTeam()
    return self.owner
end


function Board:delete()
    self:clear()
    usernameToBoard[self.owner] = nil
end



function Board:getUnits()
    -- iterates over all the units on a board.
    local set = categories.getSet(self:getTeam())

    local buffer = objects.Array()

    for _, e in ipairs(set)do
        if rgb.isUnit(e) then
            buffer:add(e)
        end
    end

    return buffer
end




function Board:getSquadronCount()
    local seenEntities = {}
    local count = 0
    for _, ent in ipairs(self:getUnits()) do
        if not seenEntities[ent] then
            seenEntities[ent] = true
            if ent.squadron then
                for _, e in ipairs(ent.squadron) do
                    seenEntities[e] = true
                end
            end
            count = count + 1
        end
    end
    return count
end




function Board:serialize()
    -- serializes the allies on the board
    local buffer = {}
    for _, ent in ipairs(self:getUnits()) do
        table.insert(buffer, ent)
    end
    self.serialized = umg.serialize(buffer)
end

function Board:deserializeAllies()
    if self.serialized then
        local arr, err = umg.deserialize(self.serialized)
        if (not arr) and err then
            print("[rgb_chess]: error in deserializing allies for board: ", err)
        end
        return arr
    else
        return {}
    end
end




function Board:clear()
    for _, ent in ipairs(self:getUnits()) do
        ent:delete()
    end
end


function Board:reset()
    --[[
        resets board state and deserializes allies.
    ]]
    self.winner = nil
    self.enemyTeam = nil

    self.lastPlayedCard = nil

    local arr = self:deserializeAllies()
    scheduling.delay(0.4, function()
        for i=1, #arr do
            rgb.setTeam(arr[i], self:getTeam())
        end
    end)
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


local function setWinners(self, selfWon, enemyWon)
    local enemy_category = self.enemyRgbTeam
    local enemyBoard = Board.getBoard(enemy_category)
    self.wonBattle = selfWon
    if enemyBoard then
        enemyBoard.wonBattle = enemyWon
    end
end


function Board:isBattleOver()
    local self_category = self.rgbTeam
    local enemy_category = self.enemyRgbTeam

    if enemy_category then
        local enemies = categories.getSet(enemy_category)
        local allies = categories.getSet(self_category)

        if enemies:size() == 0 and allies:size() == 0 then
            setWinners(self, false, false)
            return true
        end
        if enemies:size() == 0 then
            setWinners(self, true, false)
            return true
        end
        if allies:size() == 0 then
            setWinners(self, false, true)
            return true
        end
    else
        return true -- this board isn't having a fight.
    end
end



--[[
    emplaces a player onto this board
]]
function Board:emplacePlayer(player_uname)
    local x,y = self:getXY()
    local w,h = self:getWH()
    local player_ent = control.getPlayer(player_uname)
    player_ent.x = x+w/2
    player_ent.y = y+h/2
    server.unicast(player_uname, "rgbEmplacePlayer", x,y, w,h)
end



function Board:isWinner()
    return self.wonBattle
end




function Board:reroll()
    if rgb.getState() ~= rgb.STATES.TURN_STATE then
        return
    end

    local rgbTeam = self:getTeam()

    for shopIndex=1, self.shopSize do
        local delay = (shopIndex/self.shopSize) * 0.3
        scheduling.delay(delay, function()
            self:rerollCard(shopIndex)
        end)
    end

    abilities.trigger("reroll", rgbTeam)
    umg.call("reroll", rgbTeam)
end



function Board:rerollCard(shopIndex)
    local card = self:getCard(shopIndex)

    local lockEnt = self:getLockEntity(shopIndex)
    if lockEnt.isLocked then
        return -- shop slot is locked
    end

    -- else, we good to reroll
    if umg.exists(card) then
        umg.call("rerollCard", card)
        card:delete()
    end

    scheduling.delay(constants.REROLL_TIME, function()
        genCards.spawnCard(self, shopIndex)
    end)
end


function Board:getShopCards()
    local array = objects.Array()
    for i=1, self.shopSize do
        local card = self:getCard(i)
        if umg.exists(card) then
            -- card should generally always exist... but if not, we are defensive.
            array:add(card)
        end
    end
    return array
end


local isCardLockedTc = typecheck.assert("table", "number")
function Board:isCardLocked(shopIndex)
    isCardLockedTc(self, shopIndex)
    local lockEnt = self.shopLocks[shopIndex]
    return lockEnt.isLocked
end

function Board:setCardLocked(shopIndex, bool)
    local lockEnt = self.shopLocks[shopIndex]
    lockEnt.isLocked = bool
end



function Board:setLastPlayedCard(card)
    self.lastPlayedCard = card
end

function Board:getLastPlayedCard()
    return self.lastPlayedCard
end





function Board:generateItem()
    local IBD = 40 -- Minimum Item Border Distance
    local x = math.random(self.x+IBD, self.x+self.width-IBD)
    local y = math.random(self.y+IBD, self.y+self.height-IBD)
    itemPool.randomItem(self, x, y)
end




return Board

