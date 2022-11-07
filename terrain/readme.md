

# terrain mod
The Terrain Mod is used to represent impassable terrain,
such as walls, cliffs, or level edges.

It is highly customizable, and allows for destructable terrain.



## TECHNICAL DETAILS:

- Uses a custom algorithm similar to marching squares
  
- Syncing needs to be done manually
  
NOTE: <br>
Terrain objects ARE NOT SAVED AUTOMATICALLY!!! If you want to save terrain to a world, create an entity with a regular "terrain" component and do `ent.terrain = myTerrainObject`. This enables the terrain to be saved and loaded alongside the world.


PLANNING:
```lua


local tobj = terrain.Terrain({
    stepX = 16, stepY = 16, -- step amounts for noise values
    sizeX = 1000, sizeY = 1000,
    -- Optional values:
    chunkWidth = 6, chunkHeight = 6,
    x = 0, y = 0,
    noPhysics = false,
    wallTexture = graphics.newImage("my_tex.png"),
    topTexture = graphics.newImage("my_tex.png")
})


-- Clientside only:
tobj:setTopTexture("image_name") 
-- The texture for the top of the terrain
-- texture will wrap by default.

tobj:setWallTexture("image_name2")
-- The texture for the walls of the terrain
-- texture will wrap by default.



terrainObj:clear() -- clears terrain


terrainObj:setWorldPosition(x, y) -- sets world (x, y) of terrain. 



terrainObj:generateFromHeightFunction(function(x,y)
    return math.noise(x/5, y/6)
end)
-- clears all terrain, and then generates new terrain from a height function.
-- NOTE: This function will have no effect until you call terrainObj:sync()


local img = graphics.newImage("assets/my_heightmap.png")
terrainObj:generateFromImage(img, {
    imgStartX = 0, imgStartY = 0,
    imgEndX = imageWidth, imgEndY = imageHeight
})
-- generates terrain from an input image. (Heightmap image)
-- NOTE: This function will have no effect until you call terrainObj:sync()


terrainObj:addTerrain(worldX, worldY, radius)
-- adds terrain in a radius, and syncs to clients.
-- NOTE: This function will have no effect until you call terrainObj:sync()


terrainObj:removeTerrain(worldX, worldY, radius)
-- removes terrain in a radius
-- NOTE: This function will have no effect until you call terrainObj:sync()


terrainObj:sync()
-- Finalizes any changes made to the terrain, and syncs to all clients.




-- Allowing the terrain object to be saved alongside a chunk:
local chunk_ent = entities.chunk()
chunk_ent.terrain = terrainObj
```

