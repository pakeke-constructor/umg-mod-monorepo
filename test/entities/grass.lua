

return {
    swaying = {},

    init = function(ent, x,y)
        base.entityHelper.initPosition(ent,x,y)
        local rand = math.random(1, 7)
        ent.image =  "grass_" .. tostring(rand)
    end
}

