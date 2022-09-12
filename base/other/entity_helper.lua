
local ehelp = {}


local function superInit(e, ...)
    if e.super then
        e:super(...)
    end
end


function ehelp.initPosition(e, x, y, ...)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y)
    e.x = x
    e.y = y
    if e:hasComponent("z") then
        e.z = 0
    end
    superInit(e,x,y, ...)
end


function ehelp.initVelocity(e, x, y, vx, vy, ...)
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
    superInit(e,x,y,vx,vy,...)
end


return ehelp
