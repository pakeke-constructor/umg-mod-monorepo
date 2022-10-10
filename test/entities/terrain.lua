

return {
    "x","y",
    init = function(ent,x,y)
        ent.x=x
        ent.y=y
        
        ent.terrain = terrain.Terrain({
            stepX = 16, stepY = 16, -- step amounts for noise values
            sizeX = 200, sizeY = 200
        })
        ent.terrain:bindEntity(ent)
        ent.terrain:generateFromHeightFunction(function(xx, yy)
            math.noise(xx/20, yy/20)
        end)
        ent.terrain:finalize()
    end
}


