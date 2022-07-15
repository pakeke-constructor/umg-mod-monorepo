
-- gravity module

local gravityGroup = group("z", "vz")

local gravity = {}

local gravityValue = 1300 -- this seems reasonable, lol.


local function groundTest(ent)
    -- default behaviour is that ground is at z=0
    return (ent.z or 0) <= 0
end


function gravity.setGroundTest(func)
    groundTest = func
end


function gravity.setGravity(dy)
    gravityValue = dy
end


function gravity.isOnGround(ent)
    assert(exists(ent), "entity doesnt exist")
    return groundTest(ent)
end


on("update", function(dt)
    for _, ent in ipairs(gravityGroup) do
        if groundTest(ent) then
            -- force the entity to stop moving downwards.
            ent.vz = math.max(0, ent.vz)
        else
            ent.vz = ent.vz - gravityValue * dt
        end
    end
end)


return gravity

