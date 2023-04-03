
--[[
    Some small helper functions to help initialize entities easily
]]
local initializers = {}


function initializers.initXY(e, x, y)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y)
    e.x = x
    e.y = y
    return e
end


function initializers.initVxVy(e, x, y)
    e.x = x
    e.y = y
    e.vx = 0
    e.vy = 0
    return e
end


return initializers

