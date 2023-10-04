

# Components
List of components defined in the base mod.


```lua


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







ent.init = function(ent, ...) 
    -- Called when the entity is first created.
    -- `...` is the args passed to the constructor.
    -- Generally, the first two args should always be (x, y)
    ... 
end


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


