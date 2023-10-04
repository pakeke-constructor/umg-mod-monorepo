
# juice components

```lua


--[[
    TODO: Change this to progressBar.
    Have healthBar component CREATE a progressBar component at runtime
]]
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
    value = "name", --  if value is nil, `.controller` component is used.
    -- (Else, a question-bus question is asked)
}




-- renders text in front of the entity
-- (Similar to nametag component)
ent.text = {
    value = "brute",
    ox = 0, oy = -20, -- draw offsets
    scale = 1,
    overlay = true -- (text will look nicer with this enabled)
    color = {1,1,1}
}



-- please note that entities with particles break auto batching.
-- Don't use particles EVERYWHERE; it'll be slow
ent.particles = {
    type = "dust", -- `dust` is defined by juice.particles.define()
    
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




ent.animation = {
    frames = {"img1", "img2", "img3"}, 
    speed = 3
}



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


ent.rainbow = {
    period = 5, -- has a default value
    brightness = 0.2 -- has a default value
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


```
