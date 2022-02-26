

local PLAYER_SPEED = 100


return {
    "x", "y", "vx", "vy",
    "controller",
    "image",
    
    controllable = {};

    moveAnimation = {
        up = {"3d_player_up_1", "3d_player_up_2", "3d_player_up_3", "3d_player_up_4"},
        down = {"3d_player_down_1", "3d_player_down_2", "3d_player_down_3", "3d_player_down_4"}, 
        left = {"3d_player_left_1", "3d_player_left_2", "3d_player_left_3", "3d_player_left_4"}, 
        right = {"3d_player_right_1", "3d_player_right_2", "3d_player_right_3", "3d_player_right_4"},
        speed = 0.7;
        activation = 15
    };

    speed = PLAYER_SPEED;
    agility = PLAYER_SPEED * 20
}


