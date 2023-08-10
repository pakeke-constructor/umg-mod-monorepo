

# Components
List of components defined in the base mod.


```lua

ent.x
ent.y
ent.z   -- position components

ent.vx
ent.vy
ent.vz -- velocity components


ent.rot -- rotation (radians)


ent.color = {1,0.5,0.2} -- color of entity (RGBA)
-- (alpha channel is optional, defaults to 1.)

ent.image = "abc" -- Image components should be strings!
                -- This makes stuff way nicer to work with.
            -- NOTE: this means that atlases must be identical across clients!
-- if `ent.image` is nil, the entity is hidden.


ent.ox = 0 -- draw offsets for x and y.  (defaults to 0)
ent.oy = 0


-- changing ent sizes!
ent.scale = 1
ent.scaleX = 1
ent.scaleY = 1




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




ent.nametag = { -- renders a nametag above the entity
    value = "name", --  if value is nil, `.controller` component is used instead.
}


-- renders text in front of the entity
-- (Similar to nametag component)
ent.text = {
    value = "brute",
    ox = 0, oy = -20, -- draw offsets
    scale = 1,
    overlay = true -- (text will look nicer with this enabled)
}




-- please note that entities with particles break auto batching.
-- Don't use particles EVERYWHERE; it'll be slow
ent.particles = {
    type = "dust", -- `dust` is defined by visualfx.particles.define()
    
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





-- this entity can be controlled by a player.
ent.controllable = {
    -- Enables the entity to move
    movement = true

    -- ... etc.
    -- There are other extra options in here that may be specified
    -- by other, external systems
}



ent.controller = "client_id" -- whoever is controlling this entity



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


