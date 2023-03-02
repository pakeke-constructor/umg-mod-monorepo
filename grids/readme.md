

# PLANNING FOR TILES MOD:

Ok: We want to be able to-

- constrain entities to a grid
- have entities pick their image based on surrounding entities (auto-tiling)



Tile component:
```lua

ent.grid = {
    width = 16,
    height = 16, -- locks entity instances to a 16x16 grid
    
    type = "building" -- OPTIONAL: the name of the grid this entity is bound to.
    -- by default, type = entity:type()
}






--[[
imageTiling component automatically selects an appropriate image
based on surrounding components.

|---------------------------------|
|  topLeft     top     topRight   |
|   left      fill     right      |
|  bottomLeft bottom bottomRight  |
|---------------------------------|

If an image is missing, it will automatically rotate one of the others
to compensate.
]]
ent.imageTiling = {
    fill = {"fill1", "fill2", "fill3", ... }, --list of images.
    -- System will pick random from these

    isolated = {"isolated_tile1"}

    topLeft = {"topLeft1", "topLeft2"}
    topRight = "topRight" -- can also just be a string too. 
    -- String implies no random selection
    bottomLeft = {...}
    bottomRight = {...}

    right = {...}
    left = {...}
    bottom = {...}
    top = {...}
}
```


