
local Board = require("server.board")

local genCards = require("server.gen.generate_cards")



local buy = {}






local SPAWN_RANDOM_RAD = 100


local function spawnUnit(card_ent)
    --[[
        spawns a unit described by a card.
    ]]
    local board = Board.getBoard(card_ent.rgbTeam)
    local x,y = board:getXY()
    local w,h = board:getWH()
    local spawn_x = x + w/2 + (math.random()-.5) * SPAWN_RANDOM_RAD
    local spawn_y = y + h/2 + (math.random()-.5) * SPAWN_RANDOM_RAD
    
    local unit = card_ent.card.unit
    assert(entities[unit.type], "invalid unit type: " .. unit.type)
    
    local ent = entities[unit.type](spawn_x, spawn_y)

    ent.x = spawn_x
    ent.y = spawn_y
    ent.rgbTeam = card_ent.rgbTeam
    ent.rgb = card_ent.rgb
    ent.color = card_ent.color
    ent.damage = unit.damage
    ent.health = unit.health
    ent.maxHealth = unit.health
    ent.category = card_ent.rgbTeam
    board:addUnit(ent)
    -- TODO: Do feedback and stuff here.
end




function buy.buyCard(card_ent)
    local cost = card_ent.card.cost or 1
    local board = Board.getBoard(card_ent.rgbTeam)
    assert(card_ent.shopIndex)

    if card_ent.card.unit then
        spawnUnit(card_ent)
    end

    board:setMoney(board:getMoney() - cost)
    card_ent:delete()
    -- TODO: Send event to client: do feedback, sfx and stuff
    genCards.spawnCard(board, card_ent.shopIndex)
end




function buy.tryBuy(card_ent)
    --[[
        tries to buy a card entity
    ]]
    local cost = card_ent.card.cost or 1
    local board = Board.getBoard(card_ent.rgbTeam)
    if cost <= board:getMoney() then
        buy.buyCard(card_ent)
    end
end



return buy

