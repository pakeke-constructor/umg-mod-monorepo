

return {
    image = "fogmask",
    bobbing = {
        period = 31,
        magnitude = 0.3
    },
    drawDepth = 400, -- draw in front of other stuff

    init = function(e,x,y)
        base.initializers.initXY(e,x,y)
        e.color = {1,1,1,0.25}
        e.scale = 1 + math.random() * 2
        if math.random() > 0.5 then
            e.scaleX = -1
        end
        if math.random() > 0.5 then
            e.scaleY = -1
        end
    end
}

