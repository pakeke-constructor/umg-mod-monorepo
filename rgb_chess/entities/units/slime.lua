

return extend("abstract_melee", {

    defaultSpeed = 25,
    defaultHealth = 4,
    defaultAttackDamage = 1,
    defaultAttackSpeed = 0.4,

    animation = {"blob0", "blob1", "blob2", "blob3", "blob2", "blob1", speed=0.6};
    
    bobbing = {},

    init = base.entityHelper.initPosition    
})


