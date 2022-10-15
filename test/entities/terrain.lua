

return {
    "x","y",
    init = function(ent,x,y)
        ent.x=x
        ent.y=y
        
        ent.terrain = terrain.Terrain({
            stepX = 40, stepY = 40, -- step amounts for noise values
            sizeX = 2700, sizeY = 2700
        })
        ent.terrain:generateFromHeightFunction(function(xx, yy)
            return math.noise(xx/870, yy/870) 
        end)
        ent.terrain:sync()
    end
}


