

require("mortality_events")

sync.proxyEventToClient("mortality:damage")



local damageTc = typecheck.assert("entity", "number")

local function damage(ent, dmg)
    damageTc(ent, dmg)
    local dmgMult = umg.ask("mortality:getDamageTakenModifier", ent) or 1

    --[[
        TODO: Should we do a question for invincibility / invulnerability?
    ]]

    dmg = dmg * dmgMult

    -- TODO: is this in the correct order?
    -- should we change the health after emitting the callback?
    ent.health = ent.health - dmg
    umg.call("mortality:damage", ent, dmg)
end



return damage

