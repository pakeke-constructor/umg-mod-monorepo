
local PLAYER_SPEED = 290


local function shouldEmitParticles(ent)
    return math.distance(ent.vx, ent.vy) > 20
end


local function init(ent)
    ent.particles = {
        type = "dust",
        rate = 20,
        offset = {y = 8},
        spread = {x = 3, y = 0}
    }

    ent.inventory = items.Inventory({
        width=3, height = 3, 
    })
end


return {
    followCamera = true;
    canPickUpItems = true,

    color = {0.9,0.9,0.9,0.7},

    bobbing = {},
    controllable = {
        movement = true
    };
    nametag = {};

    openable = {};

    moveAnimation = {
        up = {"red_player_up_1", "red_player_up_2", "red_player_up_3", "red_player_up_4"},
        down = {"red_player_down_1", "red_player_down_2", "red_player_down_3", "red_player_down_4"}, 
        left = {"red_player_left_1", "red_player_left_2", "red_player_left_3", "red_player_left_4"}, 
        right = {"red_player_right_1", "red_player_right_2", "red_player_right_3", "red_player_right_4"},
        speed = 0.7;
        activation = 15
    };
    
    shouldEmitParticles = shouldEmitParticles,

    speed = PLAYER_SPEED;
    agility = PLAYER_SPEED * 20;

    initVxVy = true,
    init = init
}


