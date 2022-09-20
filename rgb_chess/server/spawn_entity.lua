
local Board = require("server.board")


local spawn = {}


local SPAWN_RANDOM_RAD = 300


local function doCbs(ent)
    call("summonUnit", ent)
end


function spawn.spawnEntityFromCard(card_ent, spawnX, spawnY)
    -- spawns a squadron from a card.
    -- spawnX, spawnY default to random position.
    local unit = card_ent.card.unit
    local board = Board.getBoard(card_ent.rgbTeam)
    local x,y = board:getXY()
    local w,h = board:getWH()
    local spawn_x = spawnX or x + w/2 + (math.random()-.5) * SPAWN_RANDOM_RAD
    local spawn_y = spawnY or y + h/2 + (math.random()-.5) * SPAWN_RANDOM_RAD

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

    doCbs(ent)
    return ent
end




function spawn.spawnEntity(etype, rgbTeam, spawnX, spawnY)
    --[[
        is this being used??? maybe remove this.
    ]]
    assert(rgbTeam and spawnX and spawnY, "bad args")
    local ctor = entities[etype]
    if not (ctor) then error("invalid etype: " .. etype) end
    local ent = ctor(spawnX, spawnY)
    ent.rgbTeam = rgbTeam

    doCbs(ent)
    return ent
end




return spawn
