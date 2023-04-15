
local rgbAPI = {}



local getXYassert = base.typecheck.assert("entity", "entity?")

local function getProjectileSpawn(targetEnt, sourceEnt)
    --[[
        gets the X,Y position of the projectile.
        Sensible defaults are provided if there is no sourceEntity.
    ]]
    getXYassert(targetEnt, sourceEnt)
    if umg.exists(sourceEnt) and sourceEnt.x then
        return sourceEnt.x, sourceEnt.y
    else
        local player = base.getPlayer(targetEnt.rgbTeam)
        if player then
            return player.x, player.y
        else
            return targetEnt.x, targetEnt.y
        end
    end
end




local buffTc = base.typecheck.assert("entity", "string", "number", "entity?", "number?")

function rgbAPI.buff(ent, buffType, amount, sourceEnt, depth)
    buffTc(ent, buffType, amount, sourceEnt, depth)
    assert(constants.BUFF_TYPES[buffType], "Invalid bufftype")

    local x,y = getProjectileSpawn(ent, sourceEnt)
    server.entities.buff(x,y, {
        buffAmount = amount,
        buffType = buffType,
        targetEntity = ent,
        sourceEntity = sourceEnt,
        depth = depth
    })
end



local healTc = base.typecheck.assert("entity", "number", "entity?", "number?")

function rgbAPI.heal(ent, amount, sourceEnt, depth)
    healTc(ent, amount, sourceEnt, depth)

    local x,y = getProjectileSpawn(ent, sourceEnt)
    server.entities.heal(x,y, {
        healAmount = amount,
        targetEntity = ent,
        sourceEntity = sourceEnt,
        depth = depth
    })
end



local shieldTc = base.typecheck.assert("entity", "number", "number", "entity?", "number?")

function rgbAPI.shield(ent, amount, duration, sourceEnt, depth)
    shieldTc(ent, amount, duration, sourceEnt, depth)

    local x,y = getProjectileSpawn(ent, sourceEnt)
    server.entities.shield(x,y, {
        shieldAmount = amount,
        shieldDuration = duration,
        targetEntity = ent,
        sourceEntity = sourceEnt,
        depth = depth
    })
end




rgbAPI.abilities = require("shared.abilities.abilities")



umg.expose("rgbAPI", rgbAPI)
_G.rgbAPI = rgbAPI


