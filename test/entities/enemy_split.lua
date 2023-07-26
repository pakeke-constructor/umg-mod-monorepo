


local SPEED = 85


return {
    maxHealth = 100,

    healthBar = {
        color = {1,0,0},
        shiny = true
    },

    color = {0.9,0.9,0.1},

    moveBehaviour = {
        type = "follow",
        target = "player",
        activateDistance = 600,
        deactivateDistance = 900
    },

    shadow = {
        size=6
    };

    bobbing = {},
    
    physics = {
        shape = love.physics.newCircleShape(5);
        friction = 7
    };

    onDeath = function(ent)
        if client then
            visualfx.particles.emit("smoke", ent.x, ent.y, ent.z, 5, {0.9,0.9,0})
        elseif server then
            server.entities.enemy_split(ent.x, ent.y - 5)
            server.entities.enemy_split(ent.x, ent.y + 5)
        end
    end,

    onCollide = function(ent, other_ent)
        if other_ent.image == "bullet" then -- this is SHIT.
            ent.health = ent.health - 55
        end
    end,

    moveAnimation = {
        up = {"red_player_up_1", "red_player_up_2", "red_player_up_3", "red_player_up_4"},
        down = {"red_player_down_1", "red_player_down_2", "red_player_down_3", "red_player_down_4"}, 
        left = {"red_player_left_1", "red_player_left_2", "red_player_left_3", "red_player_left_4"}, 
        right = {"red_player_right_1", "red_player_right_2", "red_player_right_3", "red_player_right_4"},
        speed = 0.7;
        activation = 15
    };

    speed = SPEED;
    agility = SPEED * 10,

    init = base.initializers.initVxVy
}


