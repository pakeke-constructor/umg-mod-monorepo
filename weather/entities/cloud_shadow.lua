


local SCALE = 4

return {
    bobbing = {
        period = 57,
        magnitude = 0.1
    },

    scale = SCALE,

    drawDepth = 500, -- draw in front of other stuff

    init = function(e,x,y)
        local cloudN = math.random(1,4)
        e.image = "cloud" .. tostring(cloudN)
        e.color = {0,0.0,0,0.3}
        if math.random() > 0.5 then
            e.scaleX = -1
        end
        if math.random() > 0.5 then
            e.scaleY = -1
        end
        base.entityHelper.initPosition(e,x,y)
    end
}

