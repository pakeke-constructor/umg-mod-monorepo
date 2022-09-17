

# terrain mod
Uses an algorithm similar to marching squares


PLANNING:
```lua


local tobj = terrain.newTerrain({
    stepX = 16, stepY = 16, -- step amounts for noise values
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

terrainObj:bindEntity(ent) -- binds an entity to this terrain object



terrainObj:generateFromHeightFunction(function(x,y)
    return math.noise(x/5, y/6)
end)
-- clears all terrain, and then generates new terrain from a height function.
-- NOTE: This function will have no effect until you call terrainObj:finalize()


local img = graphics.newImage("assets/my_heightmap.png")
terrainObj:generateFromImage(img, {
    imgStartX = 0, imgStartY = 0,
    imgEndX = imageWidth, imgEndY = imageHeight
})
-- generates terrain from an input image. (Heightmap image)
-- NOTE: This function will have no effect until you call terrainObj:finalize()


terrainObj:addTerrain(worldX, worldY, radius)
-- adds terrain in a radius, and syncs to clients.
-- NOTE: This function will have no effect until you call terrainObj:finalize()


terrainObj:removeTerrain(worldX, worldY, radius)
-- removes terrain in a radius
-- NOTE: This function will have no effect until you call terrainObj:finalize()


terrainObj:finalize()
-- Finalizes any changes made to the terrain, and syncs to all clients.
-- WARNING: if this terrain has no bound entity, no syncing will be done!!! 
-- (Instead, you'll have to sync manually.)



```

