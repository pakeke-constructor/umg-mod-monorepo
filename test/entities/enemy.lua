

local SPEED = 160


return {
    "x", "y", "z",
    "vx", "vy","vz",
    "controller",
    "image",

    color = {0.9,0.1,0.1},

    moveBehaviour = {
        type = "follow",
        target = "player",
        activateDistance = 600,
        deactivateeDistance = 900
    },

    attackBehaviour = {
        type = "melee",
        target = "player",
        range = 30
    },

    attackSpeed = 0.5,
    attackDamage = 4,

    shadow = {
        size=6
    };

    bobbing = {},
    
    physics = {
        shape = physics.newCircleShape(5);
        friction = 7
    };

    moveAnimation = {
        up = {"red_player_up_1", "red_player_up_2", "red_player_up_3", "red_player_up_4"},
        down = {"red_player_down_1", "red_player_down_2", "red_player_down_3", "red_player_down_4"}, 
        left = {"red_player_left_1", "red_player_left_2", "red_player_left_3", "red_player_left_4"}, 
        right = {"red_player_right_1", "red_player_right_2", "red_player_right_3", "red_player_right_4"},
        speed = 0.7;
        activation = 15
    };

    init = base.entityHelper.initPosition,

    speed = SPEED;
    agility = SPEED * 10
}


