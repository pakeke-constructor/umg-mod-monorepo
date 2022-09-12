
--[[

Setting defaults for this stuff:

    defaultSpeed = 20,
    defaultHealth = 10,
    defaultAttackDamage = 5,
    defaultAttackSpeed = 0.5,
]]


local defaultHealthGroup = group("defaultHealth")
defaultHealthGroup:onAdded(function(ent)
    assert(ent:isRegular("health") and ent:isRegular("maxHealth"))
    ent.health = ent.health or ent.defaultHealth
    ent.maxHealth = ent.maxHealth or ent.health
end)



local defaultSpeedGroup = group("defaultSpeed")
defaultSpeedGroup:onAdded(function(ent)
    assert(ent:isRegular("speed"))
    ent.speed = ent.speed or ent.defaultSpeed
end)


local defaultAttackDamageGroup = group("defaultAttackDamage")
defaultAttackDamageGroup:onAdded(function(ent)
    assert(ent:isRegular("attackDamage"))
    ent.attackDamage = ent.attackDamage or ent.defaultAttackDamage
end)


local defaultAttackSpeedGroup = group("defaultAttackSpeed")
defaultAttackSpeedGroup:onAdded(function(ent)
    assert(ent:isRegular("attackSpeed"))
    ent.attackSpeed = ent.attackSpeed or ent.defaultAttackSpeed
end)



