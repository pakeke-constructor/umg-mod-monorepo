
local Board = require("server.board")


local spawn = {}


local SPAWN_RANDOM_RAD = 300



function spawn.spawnUnitFromCard(card_ent, spawnX, spawnY)
    -- spawns a squadron from a card.
    -- spawnX, spawnY default to random position.
    local unit_etype = card_ent.cardBuyTarget

    local board = Board.getBoard(card_ent.rgbTeam)
    local x,y = board:getXY()
    local w,h = board:getWH()
    spawnX = spawnX or x + w/2 + (math.random()-.5) * SPAWN_RANDOM_RAD
    spawnY = spawnY or y + h/2 + (math.random()-.5) * SPAWN_RANDOM_RAD

    local ent = unit_etype(spawnX, spawnY)

    ent.x = spawnX
    ent.y = spawnY
    ent.rgbTeam = card_ent.rgbTeam
    ent.rgb = card_ent.rgb
    ent.color = card_ent.color
    ent.attackDamage = ent.defaultAttackDamage
    ent.health = ent.defaultHealth
    ent.maxHealth = ent.defaultHealth
    ent.attackSpeed = ent.defaultAttackSpeed
    ent.speed = ent.defaultSpeed
    ent.category = card_ent.rgbTeam

    call("summonUnit", ent)
    return ent
end





return spawn
