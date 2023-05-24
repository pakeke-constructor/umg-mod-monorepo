
local abilities = require("shared.abilities.abilities")


local rgbAPI = {}



local getXYassert = typecheck.assert("entity", "entity?")

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




local buffTc = typecheck.assert("entity", "string", "number", "entity?")

function rgbAPI.buff(ent, buffType, amount, sourceEnt)
    buffTc(ent, buffType, amount, sourceEnt)
    assert(constants.BUFF_TYPES[buffType], "Invalid bufftype")

    local x,y = getProjectileSpawn(ent, sourceEnt)
    server.entities.buff(x,y, {
        buffAmount = amount,
        buffType = buffType,
        targetEntity = ent,
        sourceEntity = sourceEnt,
    })
end



local healTc = typecheck.assert("entity", "number", "entity?", "number?")

function rgbAPI.heal(ent, amount, sourceEnt)
    healTc(ent, amount, sourceEnt)

    local x,y = getProjectileSpawn(ent, sourceEnt)
    server.entities.heal(x,y, {
        healAmount = amount,
        targetEntity = ent,
        sourceEntity = sourceEnt,
    })
end



local shieldTc = typecheck.assert("entity", "number", "number", "entity?")

function rgbAPI.shield(ent, amount, duration, sourceEnt)
    shieldTc(ent, amount, duration, sourceEnt)

    local x,y = getProjectileSpawn(ent, sourceEnt)
    server.entities.shield(x,y, {
        shieldAmount = amount,
        shieldDuration = duration,
        targetEntity = ent,
        sourceEntity = sourceEnt,
    })
end


local damageTc = typecheck.assert("entity", "entity", "number")

function rgbAPI.damage(sourceEnt, targetEnt, damage)
    damageTc(sourceEnt, targetEnt, damage)
    local bullet = server.entities.damage(sourceEnt.x, sourceEnt.y, {
        projectileType = constants.PROJECTILE_TYPES.DAMAGE,
        attackDamage = damage,
        targetEntity = targetEnt,
        sourceEntity = sourceEnt
    })
    bullet.color = sourceEnt.color
    -- When bullet collides, this will call rgbProjectileHit.
    return bullet
end





local function signalAbilityChange(ent)
    abilities.trigger("allyChangeAbility", ent.rgbTeam)
    umg.call("changeAbility", ent)
end



function rgbAPI.addAbility(ent, ability)
    table.insert(ent.abilities, ability)
    signalAbilityChange(ent)
end





local changeAbilityTc = typecheck.assert("entity", "table", "number")

function rgbAPI.changeAbility(ent, ability, i)
    changeAbilityTc(ent, ability, i)
    assert(abilities.isValid(ability), "?")

    i = math.min(#ent.abilities, i)
    ent.abilities[i] = table.copy(ability, true) -- 2nd argument = deepcopy
    signalAbilityChange(ent)
    sync.syncComponent(ent, "abilities")
end



function rgbAPI.levelUpUnitEntity(ent)
    assert(rgb.isUnit(ent), "?")
    ent.level = (ent.level or 1) + 1

    abilities.trigger("allyLevelUp", ent.rgbTeam)
    umg.call("levelUp", ent, ent.level)
    sync.syncComponent(ent, "level")
end




local changeRGBTc = typecheck.assert("entity", "table")

function rgbAPI.changeRGB(ent, newRGB)
    changeRGBTc(ent, newRGB)
    if not rgb.exactMatch(ent.rgb, newRGB) then
        ent.rgb = newRGB
        sync.syncComponent(ent, "rgb")
        umg.call("changeRGB", ent, newRGB)
        abilities.trigger()
    end
end



umg.expose("rgbAPI", rgbAPI)
_G.rgbAPI = rgbAPI


