
local BRUTE_DEFAULT_DMG = 5
local BRUTE_DEFAULT_HP = 10
local BRUTE_DEFAULT_ATTACKSPEED = 0.5


return extend("abstract_melee", {
    moveAnimation = {
        up = {"blank_player_up_1", "blank_player_up_2", "blank_player_up_3", "blank_player_up_4"},
        down = {"blank_player_down_1", "blank_player_down_2", "blank_player_down_3", "blank_player_down_4"}, 
        left = {"blank_player_left_1", "blank_player_left_2", "blank_player_left_3", "blank_player_left_4"}, 
        right = {"blank_player_right_1", "blank_player_right_2", "blank_player_right_3", "blank_player_right_4"},
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


