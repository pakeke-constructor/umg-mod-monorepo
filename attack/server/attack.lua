

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




local function applyAttack(attacker_ent, victim_ent, effectiveness)
    --[[
        effectiveness is a value from 0-1, denoting how effective
        the attack is.
        Splash damage with falloff is less effective.
    ]]
    umg.call("attack", attacker_ent, victim_ent, effectiveness)
    server.broadcast("attack", attacker_ent, victim_ent, effectiveness)
end


local doSplashTc = base.typecheck("entity", "number", "number", "string")

local function doSplash(ent, hitx, hity, category)
    --[[
        executes a splash damage attack.
        `target_ent` is where the attack will take place,
        however other entities may be hit too.
    ]]
    doSplashTc(ent, hitx, hity, category)
    local splash = ent.attackBehaviour.splash
    
    if category then
        for _, e in ipairs(categories.getSet(category)) do
            if math.distance(e.x-hitx, e.y-hity) <= splash.radius then
                if e ~= ent then
                    -- we dont want the entity hitting itself!
                    local falloffType = splash.damageFalloff or "none"
                    local dmg = falloffs[falloffType](
                        ent.attackDamage, 
                        e.x-hitx, e.y-hity,
                        splash.radius
                    )
                    applyAttack(ent, e, dmg)
                end
            end
        end

        if splash.shockwave then
            base.client.shockwave(hitx, hity, 0, splash.radius, 2, 0.4)
        end
    end
end



local attack = {}

function attack.attack(ent, target_ent)
    assert(ent.attackBehaviour, "Entity needs attackBehaviour to attack")
    if ent.attackBehaviour.splash then
        doSplash(ent, target_ent)
    else
        assert(umg.exists(ent), "Ent didn't exist!! (TODO: Theres a bug here)")
        assert(umg.exists(target_ent), "Target ent didn't exist!! (TODO: Theres a bug here)")
        applyAttack(ent, target_ent, 1)
    end
end

function attack.splashAttack(ent, target_ent)
    local category = target_ent.category
    doSplash(ent, target_ent.x, target_ent.y, category)
end


return attack
