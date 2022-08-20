

local PLAYER_SPEED = 160


local function player_slotExists(_, x, y)
    return (x > 1) and (y > 1)
end



return {
    "x", "y", "z",
    "vx", "vy","vz",
    "controller",
    "image",
    "inventory",

    "color",

    "faceDirection",

    "health",
    maxHealth = 100,

    healthBar = {
        offset = 20,
        drawWidth = 60,
        color = {0,1,0}
    },

    category = "player",

    follow = true;

    inventoryCallbacks = {
        slotExists = player_slotExists
    };

    shadow = {
        size=6
    };

    bobbing = {},
    
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
    agility = PLAYER_SPEED * 20;

    init = function(e, x, y)
        e.x = x
        e.y = y
        e.health = e.maxHealth
        e.inventory = {width=7, height = 4}
    end
}


