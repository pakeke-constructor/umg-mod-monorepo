

# Components
List of components defined in the base mod.


```lua

ent.x
ent.y
ent.z   -- position components

ent.vx
ent.vy
ent.vz -- velocity components



ent.image = "abc" -- Image components should be strings!
                -- This makes stuff way nicer to work with.
            -- NOTE: this means that atlases must be identical across clients!

ent.animation = {"img1", "img2", "img3", speed = 3} -- Same as animations- 
    -- images should be put as strings.


ent.moveAnimation = {
    up = {"up1", "up2", ...},
    down = ...,  left = ..., right = ...
    speed = 3
}  -- Similar to PushOps;
-- in same format as ent.animation



ent.swaying, ent.bobbing


-- changing ent sizes!
-- (This should also affect the size of the physics body too.)
ent.scale
ent.scale_x
ent.scale_y


ent.riding -- This entity rides another entity!


ent.trail = {
    -- like `friction` component in PushOps; leaves a particle trail.
}

ent.particles = {
    type = "dust",
    ox = 0;
    oy = 40
}


-- this entity can be controlled by a player
--[[  Buttons:
up:    W
left:  A
down:  S
right: D
^^^ These are handled automatically by the base mod.

left_ability:  Q
right_ability: E
space_ability: Space bar
]]
ent.controllable = {
    speed = 10;
    controller = "player_username";
     -- Warning: these functions are called on serverside AND clientside!!!
    on_left_ability = function(ent) end;
    on_right_ability = function(ent) end;
    on_space_ability = function(ent) end;

    on_click = function(ent, x, y) end;
}




ent.on_damage = function(ent) ... end

ent.on_death = function(ent) ... end

ent.on_update = function(ent, dt)   end

ent.on_draw = function(ent) end  --  called when ent is drawn

ent.on_collide = function(ent, other, speed)   end

ent.on_spawn = function(s)


```


