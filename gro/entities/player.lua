
local PLAYER_SPEED = 90


return {
    "x", "y", "z",
    "vx", "vy","vz",
    "controller",
    "image",
    "inventory",

    "faceDirection",

    follow = true;

    bobbing = {},
    
    controllable = {};

    nametag = {};

    physics = {
        shape = physics.newCircleShape(5);
        friction = 7
    };

    light = {
        radius = 120
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
    agility = PLAYER_SPEED * 20;

    init = function(e, username)
        e.x = 0
        e.y = 0
        e.z = 0
        e.controller = username
        e.inventory = {width = 8, height = 8}
    end;
}


