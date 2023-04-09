
local rgbAPI = {}



local spawnProjectileTc = base.typecheck.assert("entity", "entity", "table", "number?")

local function spawnProjectile(targetEnt, sourceEnt, options, depth)
    spawnProjectileTc(targetEnt, sourceEnt, options, depth)
    local team = targetEnt.rgbTeam
    local player = base.getPlayer(team)
    local x,y = player.x, player.y
    if umg.exists(sourceEnt) then
        x,y = sourceEnt.x, sourceEnt.y
    end
    options.targetEntity = targetEnt
    options.sourceEntity = sourceEnt
    options.depth = depth or 0
    server.entities.projectile(x,y,options)
end



local buffTc = base.typecheck.assert("entity", "string", "number", "entity?", "number?")

function rgbAPI.buff(ent, buffType, amount, sourceEnt, depth)
    buffTc(ent, buffType, amount, sourceEnt, depth)
    assert(constants.BUFF_TYPES[buffType], "Invalid bufftype")

    spawnProjectile(ent, sourceEnt, {
        projectileType = constants.PROJECTILE_TYPES.BUFF,
        buffAmount = amount,
        buffType = buffType
    }, depth)
end



local healTc = base.typecheck.assert("entity", "number", "entity?", "number?")

function rgbAPI.heal(ent, amount, sourceEnt, depth)
    healTc(ent, amount, sourceEnt, depth)

    spawnProjectile(ent, sourceEnt, {
        projectileType = constants.PROJECTILE_TYPES.HEAL,
        healAmount = amount
    }, depth)
end


local shieldTc = base.typecheck.assert("entity", "number", "entity?", "number?")

function rgbAPI.shield(ent, amount, sourceEnt, depth)
    shieldTc(ent, amount, sourceEnt, depth)

    spawnProjectile(ent, sourceEnt, {
        projectileType = constants.PROJECTILE_TYPES.HEAL,
        shieldAmount = amount
    }, depth)
end


_G.rgbAPI = rgbAPI
umg.expose("rgbAPI", rgbAPI)
