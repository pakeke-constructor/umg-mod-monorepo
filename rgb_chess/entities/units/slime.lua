
local SLIME_DEFAULT_DMG = 1
local SLIME_DEFAULT_HP = 4
local SLIME_DEFAULT_ATTACKSPEED = 0.4



return extend("abstract_melee", {

    animation = {"blob0", "blob1", "blob2", "blob3", "blob2", "blob1", speed=0.6};

    bobbing = {},

    init = function(ent, x, y)
        ent.x = x;
        ent.y = y;
        
        ent.attackDamage = SLIME_DEFAULT_DMG
        ent.attackSpeed = SLIME_DEFAULT_ATTACKSPEED
        ent.health = SLIME_DEFAULT_HP
        ent.maxHealth = SLIME_DEFAULT_HP
    end;
})


