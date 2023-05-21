
local Board = require("server.board")
local abilities = require("server.abilities.abilities")


local spawn = {}


local SPAWN_RANDOM_RAD = 300



local spawnTc = typecheck.assert("table", {
    x = "number",
    y = "number",
    rgbTeam = "string",
    rgb = "table"
})

function spawn.spawn(etype, args)
    spawnTc(etype, args)

    local ent = etype(args.x, args.y)

    ent.rgbTeam = args.rgbTeam
    ent.category = args.rgbTeam

    ent.rgb = args.rgb
    ent.color = rgb.rgbToColor(args.rgb)

    ent.attackDamage = ent.defaultAttackDamage
    ent.health = ent.defaultHealth
    ent.maxHealth = ent.defaultHealth
    ent.attackSpeed = ent.defaultAttackSpeed
    ent.speed = ent.defaultSpeed

    umg.call("summonUnit", ent)
    abilities.trigger("allySummoned", ent.rgbTeam)

    return ent
end



function spawn.spawnUnitFromCard(card_ent, spawnX, spawnY)
    -- spawns a squadron from a card.
    -- spawnX, spawnY default to random position.
    local unit_etype = card_ent.cardBuyTarget

    local board = Board.getBoard(card_ent.rgbTeam)
    local x,y = board:getXY()
    local w,h = board:getWH()
    spawnX = spawnX or x + w/2 + (math.random()-.5) * SPAWN_RANDOM_RAD
    spawnY = spawnY or y + h/2 + (math.random()-.5) * SPAWN_RANDOM_RAD

    local ent = spawn.spawn(unit_etype, {
        x = spawnX, y = spawnY,
        rgbTeam = card_ent.rgbTeam,
        rgb = card_ent.rgb,
        color = card_ent.color
    })

    return ent
end





return spawn
