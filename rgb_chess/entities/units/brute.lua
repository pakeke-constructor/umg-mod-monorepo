
local BRUTE_DEFAULT_DMG = 5
local BRUTE_DEFAULT_HP = 10
local BRUTE_DEFAULT_ATTACKSPEED = 0.5


return extend("abstract_melee", {
    moveAnimation = {
        up = {"enemy_up_1", "enemy_up_2", "enemy_up_3", "enemy_up_4"},
        down = {"enemy_down_1", "enemy_down_2", "enemy_down_3", "enemy_down_4"}, 
        left = {"enemy_left_1", "enemy_left_2", "enemy_left_3", "enemy_left_4"}, 
        right = {"enemy_right_1", "enemy_right_2", "enemy_right_3", "enemy_right_4"},
        speed = 0.7;
        activation = 15
    };

    init = function(ent, x, y)
        ent.x = x;
        ent.y = y;
        
        ent.attackDamage = BRUTE_DEFAULT_DMG
        ent.attackSpeed = BRUTE_DEFAULT_ATTACKSPEED
        ent.health = BRUTE_DEFAULT_HP
        ent.maxHealth = BRUTE_DEFAULT_HP
    end;
})


