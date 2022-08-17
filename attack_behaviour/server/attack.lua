


local falloffs = {
    none = function(dmg, x, y, rad) return dmg end;
    linear = function(dmg, x, y, rad)
        return dmg * (1-(math.distance(x,y) / rad))
    end;
    quadratic = function(dmg, x, y, rad)
        return dmg * (1-(math.distance(x,y) / rad) ^ 2)
    end
}


local function doSplash(ent, target_ent)
    --[[
        executes a splash damage attack.
        `target_ent` is where the attack will take place,
        however other entities may be hit too.
    ]]
    local category = target_ent.category
    local hitx, hity = target_ent.x, target_ent.y
    local splash = ent.attackBehaviour.splash

    if category then
        for _, e in categories.getSet(category):ipairs() do
            if math.distance(e, target_ent) <= splash.radius then
                if e ~= ent then
                    -- we dont want to entity hitting itself!
                    local falloffType = splash.damageFalloff or "none"
                    local dmg = falloffs[falloffType](
                        ent.attackDamage, 
                        e.x-hitx, e.y-hity,
                        splash.radius
                    )
                    call("attack", ent, e, dmg)
                    e.health = e.health - ent.attackDamage
                end
            end
        end

        if splash.shockwave then
            base.shockwave(hitx, hity, 0, splash.radius, 2, 0.4)
        end
    end
end



local function attack(ent, target_ent)
    --[[
        TODO: Do particle effects here maybe?
    ]]
    if ent.attackBehaviour.splash then
        doSplash(ent, target_ent)
    else
        call("attack", ent, target_ent, ent.attackDamage)
        target_ent.health = target_ent.health - ent.attackDamage
    end
end


return attack
