


return extend("abstract_melee", {

    defaultSpeed = 60,
    defaultHealth = 10,
    defaultAttackDamage = 5,
    defaultAttackSpeed = 0.5,

    bobbing = {},

    moveAnimation = {
        up = {"enemy_up_1", "enemy_up_2", "enemy_up_3", "enemy_up_4"},
        down = {"enemy_down_1", "enemy_down_2", "enemy_down_3", "enemy_down_4"}, 
        left = {"enemy_left_1", "enemy_left_2", "enemy_left_3", "enemy_left_4"}, 
        right = {"enemy_right_1", "enemy_right_2", "enemy_right_3", "enemy_right_4"},
        speed = 0.7;
        activation = 15
    };

    init = base.entityHelper.initPosition

})


