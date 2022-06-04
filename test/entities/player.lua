

local PLAYER_SPEED = 160


return {
    "x", "y", "vx", "vy",
    "controller",
    "image",
    "inventory",

    "color",

    bobbing = {},

    follow = true,
    
    controllable = {};

    nametag = {};

    physics = {
        shape = physics.newCircleShape(5);
        friction = 7
    };

    light = {
        radius = 150;
        color = {1,1,1}
    };

    moveAnimation = {
        up = {"red_player_up_1", "red_player_up_2", "red_player_up_3", "red_player_up_4"},
        down = {"red_player_down_1", "red_player_down_2", "red_player_down_3", "red_player_down_4"}, 
        left = {"red_player_left_1", "red_player_left_2", "red_player_left_3", "red_player_left_4"}, 
        right = {"red_player_right_1", "red_player_right_2", "red_player_right_3", "red_player_right_4"},
        speed = 0.7;
        activation = 15
    };

    speed = PLAYER_SPEED;
    agility = PLAYER_SPEED * 20
}


