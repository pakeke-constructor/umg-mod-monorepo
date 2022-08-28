
local HUHU_DEFAULT_DMG = 1
local HUHU_DEFAULT_HP = 1
local HUHU_DEFAULT_ATTACKSPEED = 0.4


return extend("abstract_melee", {
    animation = {
        ""
    }

    init = function(ent, x, y)
        ent.x = x;
        ent.y = y;
        
        ent.attackDamage = HUHU_DEFAULT_DMG
        ent.attackSpeed = HUHU_DEFAULT_ATTACKSPEED
        ent.health = HUHU_DEFAULT_HP
        ent.maxHealth = HUHU_DEFAULT_HP
    end;
})


