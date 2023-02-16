
local ehelp = {}


function ehelp.initPosition(e, x, y, ...)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y)
    e.x = x
    e.y = y
end


function ehelp.initPositionVelocity(e, x, y, vx, vy)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y, vx,vy)
    e.x = x
    e.y = y
    e.vx = vx or 0
    e.vy = vy or 0
end


return ehelp

