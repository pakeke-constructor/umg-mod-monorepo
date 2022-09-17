
return {
    "x","y","terrain",
    init = function(e,x,y)
        e.x=x; e.y=y
        e.terrain = terrain.Terrain({
            stepX = 16,
            stepY = 16,
            ownerEntity = e,
            worldX = x,
            worldY = y
        })
    end
}

