

# terrain mod
Uses marching squares


PLANNING:
```lua


local tobj = terrain.newTerrain({
    stepX = 16, stepY = 16, -- step amounts for marching squares
    sizeX = 1000, sizeY = 1000,
    -- Optional values:
    worldX = 100, worldY = 100,
    noPhysics = false,
})


-- Clientside only:
tobj:setTopTexture("image_name") 
-- The texture for the top of the terrain
-- texture will loop by default.

tobj:setWallTexture("image_name2")
-- The texture for the walls of the terrain
-- texture will loop by default.



terrainObj:clear() -- clears terrain

terrainObj:setWorldPosition(x, y) -- sets world (x, y) of terrain. 
-- (this should usually be the entity x,y position)

terrainObj:generateFromHeightFunction(math.noise)
-- clears all terrain, and then generates new terrain from a height function.


local img = graphics.newImage("assets/my_heightmap.png")
terrainObj:generateFromImage(img, {
    imgStartX = 0, imgStartY = 0,
    imgEndX = imageWidth, imgEndY = imageHeight
})
-- generates terrain from an input image. (Heightmap image)


terrainObj:addTerrain(worldX, worldY, radius)
-- adds terrain in a radius

terrainObj:removeTerrain(worldX, worldY, radius)
-- removes terrain in a radius




```

