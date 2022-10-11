

return {
    "x","y",
    init = function(ent,x,y)
        ent.x=x
        ent.y=y
        
        ent.terrain = terrain.Terrain({
            stepX = 16, stepY = 16, -- step amounts for noise values
            sizeX = 700, sizeY = 700
        })
        ent.terrain:generateFromHeightFunction(function(xx, yy)
            return math.noise(xx/270, yy/270) 
        end)
        ent.terrain:sync()
    end
}


