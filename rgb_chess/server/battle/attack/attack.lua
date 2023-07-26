

local shieldAPI = require("server.engine.shields")
local rgbAPI = require("server.engine.rgb_api")

local abilities = require("shared.abilities.abilities")


-- Damage falloffs for splash damage
local falloffs = {
    none = function(x, y, rad) return 1 end;
    linear = function(x, y, rad)
        return (1-(math.distance(x,y) / rad))
    end;
    quadratic = function(x, y, rad)
        return (1-(math.distance(x,y) / rad) ^ 2)
    end
}




local function applyAttack(attackerEnt, targetEnt, damage)
    --[[
        effectiveness is a value from 0-1, denoting how effective
        the attack is.
        Splash damage with falloff is less effective.
    ]]
    umg.call("attack", attackerEnt, targetEnt, damage)
    server.broadcast("attack", attackerEnt, targetEnt, damage)

    damage = shieldAPI.getDamage(targetEnt, damage)
    targetEnt.health = targetEnt.health - damage
    abilities.trigger("allyDamage", targetEnt.rgbTeam)
    abilities.trigger("allyAttack", attackerEnt.rgbTeam)
    umg.call("rgbAttack", attackerEnt, targetEnt, damage)
end




local doSplashTc = typecheck.assert("entity", "number", "number", "string", "number")

local function doSplash(ent, hitx, hity, category, damage)
    --[[
        executes a splash damage attack.
        `target_ent` is where the attack will take place,
        however other entities may be hit too.
    ]]
    doSplashTc(ent, hitx, hity, category, damage)
    local splash = ent.attackBehaviour.splash
    damage = damage or ent.power
    
    if category then
        for _, e in ipairs(categories.getSet(category)) do
            if math.distance(e.x-hitx, e.y-hity) <= splash.radius then
                if e ~= ent then
                    -- we dont want the entity hitting itself!
                    local falloffType = splash.damageFalloff or "none"
                    local falloff = falloffs[falloffType](
                        e.x-hitx, e.y-hity,
                        splash.radius
                    )
                    local dmg = damage * falloff
                    applyAttack(ent, e, dmg)
                end
            end
        end

        if splash.shockwave then
            visualfx.shockwave(hitx, hity, 0, splash.radius, 2, 0.4)
        end
    end
end



local attack = {}

local attackTc = typecheck.assert("entity", "entity", "number?")

function attack.attack(ent, target_ent, damage)
    attackTc(ent, target_ent, damage)
    assert(ent.attackBehaviour, "Entity needs attackBehaviour to attack")
    damage = damage or ent.power
    if ent.attackBehaviour.splash then
        doSplash(ent, target_ent.x, target_ent.y, target_ent.category, damage)
    else
        applyAttack(ent, target_ent, damage)
    end
end



function attack.splashAttack(ent, target_ent, damage)
    attackTc(ent, target_ent, damage)
    assert(ent.attackBehaviour, "Entity needs attackBehaviour to attack")
    damage = damage or ent.power
    local category = target_ent.category
    doSplash(ent, target_ent.x, target_ent.y, category)
end


return attack
