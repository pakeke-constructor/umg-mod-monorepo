


local function damage(ent, dmg)
    local dmgMult = umg.ask("mortality:getDamageTakenModifier", ent)

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

