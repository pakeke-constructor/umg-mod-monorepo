
local SLIME_DEFAULT_DMG = 1
local SLIME_DEFAULT_HP = 4
local SLIME_DEFAULT_ATTACKSPEED = 0.4


return {
    "x", "y",
    "vx", "vy",
    "image",
    "color",
    "category",

    "rgb",
    "rgb_team", -- the team this entity is in

    "attackDamage", "attackSpeed",
    "hp", "maxHp",

    speed = 70,

    attackBehaviour = {};

    moveBehaviour = {
        type = "follow";
        activateDistance = 1000,
    };

    animation = {"huhu1","huhu2","huhu3","huhu2", speed=0.6};

    init = function(ent, x, y)
        ent.x = x;
        ent.y = y;
        
        ent.attackDamage = SLIME_DEFAULT_DMG
        ent.attackSpeed = SLIME_DEFAULT_ATTACKSPEED
        ent.health = SLIME_DEFAULT_HP
        ent.maxHealth = SLIME_DEFAULT_HP
    end;
}
