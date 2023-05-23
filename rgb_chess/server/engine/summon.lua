

local Board = require("server.board")
local abilities = require("shared.abilities.abilities")


local summon = {}


local SPAWN_RANDOM_RADIUS = 300



local function getDefaultPosition(rgbTeam)
    local board = Board.getBoard(rgbTeam)
    local x,y = board:getXY()
    local w,h = board:getWH()
    local summonX = x + w/2 + (math.random()-.5) * SPAWN_RANDOM_RADIUS
    local summonY = y + h/2 + (math.random()-.5) * SPAWN_RANDOM_RADIUS
    return summonX, summonY
end




local summonTc = typecheck.assert("table", {
    x = "number?",
    y = "number?",
    rgbTeam = "string",
    rgb = "table"
})

function summon.summon(etype, args)
    summonTc(etype, args)

    local summonX, summonY = args.x, args.y
    if (not summonX) or (not summonY) then
        summonX, summonY = getDefaultPosition(args.rgbTeam)
    end

    local ent = etype(summonX, summonY)

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



return summon
