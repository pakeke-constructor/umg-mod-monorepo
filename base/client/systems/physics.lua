


local physics_ents = group("physics", "pos")

--[[

Handles all entities that require physics in the game.


]]


local fixture_to_ent = {}
local ent_to_fixture = {}



local world -- The box2d physics world used by entities


local function beginContact(fixture_A, fixture_B, contact_obj)
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]

end





on("newWorld", function()    
    if world then
        world:destroy()
    end
    world = physics.newWorld(0,0)
    world:setCallbacks(beginContact, nil, nil, nil)
end)



on("update", function(dt)
    world:update(dt) 
end)







local allowedTypes = {
    kinematic = true; dynamic = true; static=true
}
local er1 = [[
Illegal physics.type value: %s
Must be one of the following:  "kinematic", "dynamic", or "static"
]]

local function getBodyType(ent)
    if ent.physics.type then
        if not allowedTypes[ent.physics.type] then
            error(er1:format(tostring(ent.physics.type)))
        end
        return ent.physics.type
    else
        if ent.vx and ent.vy then
            return "dynamic"
        else
            return "static"
        end
    end
end


local DEFAULT_FRICTION = 0.3

local function initialize(ent)
    local body = physics.newBody(
        world, ent.pos.x, ent.pos.y, getBodyType(ent)
    )

    local fixture = physics.newFixture(body, ent.physics.shape)

    if ent.physics.friction then
        ent.physics.body:setLinearDamping(ent.physics.friction or DEFAULT_FRICTION)
    end

    fixture_to_ent[fixture] = ent
    ent_to_fixture[ent] = fixture
end





physics_ents:on_added(function(ent)
    --[[
        will be in form:
        ent.physics = {
            shape = love.physics.newShape( )
            type = "kinetic"
        }
    ]]
    if world:isLocked( ) then 
        error("World was locked! This is a bug on my behalf, sorry")  
    end

    initialize(ent)
end)



physics_ents:on_removed(function(ent)
    fixture_to_ent[ent.physics.fixture] = nil

    if not ent.physics.fixture:isDestroyed() then
        ent.physics.fixture:destroy()
    end

    if not ent.physics.body:isDestroyed() then
        ent.physics.body:destroy()
    end

    -- Dont need to destroy the shape, 
    -- as it is shared between all ent instances.
end)


