

# Components
List of components defined in the base mod.


```lua

ent.x
ent.y
ent.z   -- position components

ent.vx
ent.vy
ent.vz -- velocity components


ent.color = {1,0.5,0.2} -- colour (RGBA)

ent.image = "abc" -- Image components should be strings!
                -- This makes stuff way nicer to work with.
            -- NOTE: this means that atlases must be identical across clients!
-- if `ent.image` is nil, the entity is hidden.


ent.animation = {"img1", "img2", "img3", speed = 3} -- Same as animations- 
    -- images should be put as strings.


ent.moveAnimation = {
    up = {"up1", "up2", ...},
    down = ...,  left = ..., right = ...
    speed = 3;

    activation = 10 -- moveAnimation activates when entity is travelling at 
    -- at least 10 units per second.
}




ent.swaying = {
    magnitude = 1;
    period = 2
}

ent.bobbing = {
    period = 0.8;
    magnitude = 0.15
}

ent.spinning = {
    period = 2;
    magnitude = 1
}


-- changing ent sizes!
-- (This should also affect the size of the physics body too.)
ent.scale
ent.scaleX
ent.scaleY


ent.riding -- This entity rides another entity!


ent.trail = {
    -- like `friction` component in PushOps; leaves a particle trail.
}

ent.particles = {
    type = "dust",
    ox = 0;
    oy = 40
}


ent.physics = {
    shape = love.physics.Shape(...), -- some shape object (compulsory)

    -- OPTIONAL FIELDS:
    friction = 6, -- friction number.  (default is 6),

    type = "kinematic" -- The bodyType of the entity. 
    -- Default is `static` or `dynamic`, depending on whether the 
        -- ent has vx and vy components.
}


ent.friction = 3.15 -- friction number. (default is roughtly 3.15)



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
    onLeftAbility = function(ent) end;
    onRightAbility = function(ent) end;
    onSpaceAbility = function(ent) end;

    onClick = function(ent, x, y) end;
}

ent.controller = "player_username" -- whoever is controlling this entity

ent.follow = false -- Whether the camera should follow this ent or not.


ent.speed = 100 -- The speed the ent moves at

ent.agility = 50 -- How fast the ent can change it's speed (acceleration)
-- By default, agility = ent.speed



ent.inventory = {
    width = 3, -- 3 slots wide
    height = 6 -- 6 slots high.
}



ent.init = function(ent) ... end
-- Called when the entity is first created.

ent.damaged = function(ent) ... end

ent.death = function(ent) ... end

ent.update = function(ent, dt)   end

ent.draw = function(ent) end  --  called when ent is drawn

ent.collide = function(ent, other_ent)
    -- called when 2 ents collide. (both must have physics component)
end

ent.spawn = function(s, x, y)
    -- Called when entity is spawned, with x,y values
end


```


