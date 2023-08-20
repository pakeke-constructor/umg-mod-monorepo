

--[[
    Some small helper functions to help initialize entities easily
]]
local initializers = {}

local positionTc = typecheck.assert("number", "number")


function initializers.initXY(e, x, y)
    -- if this is set as the ent.init method, you can do entities.my_entity(x,y)
    positionTc(x, y)
    e.x = x
    e.y = y
    return e
end


function initializers.initVxVy(e, x, y)
    positionTc(x, y)
    e.x = x
    e.y = y
    e.vx = 0
    e.vy = 0
    return e
end



local function check2Numbers(x, y)
    if type(x) == "number" and type(y) == "number" then
        return true
    end
    return false
end


umg.on("@entityInit", function(ent, x, y)
    if ent.initXY then
        -- initialize x, y comps
        if check2Numbers(x, y) then
            ent.x = x
            ent.y = y
        end

    elseif ent.initVxVy then
        -- initialize x, y,
        -- and also velocity comps.
        if check2Numbers(x, y) then
            ent.x = x
            ent.y = y
            ent.vx = 0
            ent.vy = 0
        end
    end
end)




return initializers

