

# Components
List of components defined in the base mod.


```lua

ent.x
ent.y
ent.z   -- position components

ent.vx
ent.vy
ent.vz -- velocity components


ent.color = {1,0.5,0.2} -- color of entity (RGBA)
-- (alpha channel is optional, defaults to 1.)

ent.image = "abc" -- Image components should be strings!
                -- This makes stuff way nicer to work with.
            -- NOTE: this means that atlases must be identical across clients!
-- if `ent.image` is nil, the entity is hidden.

ent.ox = 0 -- draw offsets for x and y.  (defaults to 0)
ent.oy = 0


ent.animation = {"img1", "img2", "img3", speed = 3} -- Same as animations- 
    -- images should be put as strings.


ent.moveAnimation = {
    up = {"up1", "up2", ...},
    down = ...,  left = ..., right = ...
    speed = 3;

    activation = 10 -- moveAnimation activates when entity is travelling at 
    -- at least 10 units per second.
}



ent.shadow = {
    size = 10; -- default value is the size of the entity image / 2.
    color = {0,0,0,0.4} -- <--- default value; this is the color of the shadow.
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
ent.scale = 1
ent.scaleX = 1
ent.scaleY = 1


ent.riding = horse_ent



ent.friction = 3.15 -- friction number. (default is roughtly 3.15)


ent.health = 10 -- must be regular
ent.maxHealth = 10 -- can be shared.

ent.healthBar = { -- health bar above entity!
    -- All of these are optional values:
    offset = 10, -- how high it's drawn
    drawWidth = 20,
    drawHeight = 5,
    healthColor = {1,0.2,0.2},
    outlineColor = {0,0,0},
    backgroundColor = {0.4,0.4,0.4,0.4}
}


ent.nametag = { -- creates a nametag above the entity
    value = "name", --  if value is nil, `.controller` component is used instead.
}



-- please note that entities with particles break auto batching.
-- Don't use particles EVERYWHERE; it'll be slow
ent.particles = {
    type = "dust", -- `dust` is defined by base.particles.define()
    
    -- OPTIONAL FIELDS:
    rate = 5, -- emits 5 particles per second (default = 5)
    spread = {x = 4, y = 4}, -- particle emit spread
    offset = {x = 0, y = 20}, -- draw offsets for x and y.
    -- (^^^ for example, if you wanted to draw the particles at feet of entity.)
}

-- entities can also have multiple particles attatched to them:
ent.particles = {
    { type = "smoke", offset = {x = 0, y = 20} },
    { type = "dust", offset = {x = 0, y = 20} }
    -- ^^^ these take same args as above.
}

ent.shouldEmitParticles = function(ent)
    return true -- whether this entity should emit particles or not.
    -- for example, good for running. If entity speed > X, return true,
end 




ent.physics = {
    shape = love.physics.Shape(...), -- some shape object (compulsory)

    -- OPTIONAL FIELDS:
    friction = 6, -- friction number.  (default is 6),

    type = "kinematic" -- The bodyType of the entity. 
    -- Default is `static` or `dynamic`, depending on whether the 
        -- ent has vx and vy components.
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



ent.init = function(ent, ...) 
    -- Called when the entity is first created.
    -- `...` is the args passed to the constructor.
    -- Generally, the first two args should always be (x, y)
    ... 
end



ent.onDeath = function(ent) ... end

ent.onUpdate = function(ent, dt)   end

ent.onDraw = function(ent) end  --  called when ent is drawn

ent.onCollide = function(ent, other_ent)
    -- called when 2 ents collide. (both must have physics component)
end

ent.onClick = function(ent, username, button, x, y)
    -- called when ent is clicked by `username`. 
    -- (`ent` must have an x, y position.)
end



```


