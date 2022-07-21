
local ehelp = {}


function ehelp.initPosition(e, x, y)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y)
    e.x = x
    e.y = y
    if e:hasComponent("z") then
        e.z = 0
    end
end


function ehelp.initVelocity(e, x, y, vx, vy)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y, vx,vy)
    e.x = x
    e.y = y
    if e:hasComponent("z") then
        e.z = 0
    end
    e.vx = vx
    e.vy = vy
    if e:hasComponent("vz") then
        e.vz = 0
    end
end


return ehelp
