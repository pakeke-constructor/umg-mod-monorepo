


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
    if ent_A.collide then
        ent_A.collide(ent_A, ent_B)
    end
    if ent_B.collide then
        ent_B.collide(ent_B, ent_A)
    end
end





on("newWorld", function()    
    if world then
        world:destroy()
    end
    world = physics.newWorld(0,0)
    world:setCallbacks(beginContact, nil, nil, nil)
end)



local function preUpdateEnt(ent)
    --[[
        Changes box2d body position if needed
    ]]
    local fixture = ent_to_fixture[ent]
    local body = fixture:getBody()
    local pre_x, pre_y = body:getPosition()
    if ent.x ~= pre_x or ent.y ~= pre_y then
        body:setPosition(ent.x, ent.y)
    end

    if ent.vx or ent.vy then
        local pre_vx, pre_vy = body:getLinearVelocity()
        if ent.vx ~= pre_vx or ent.vy ~= pre_vy then
            body:setLinearVelocity(ent.vx, ent.vy)
        end
    end
end


local function postUpdateEnt(ent)
    --[[
        updates .x .y  and .vx .vy  values based on the physics body
    ]]
    local fixture = ent_to_fixture[ent]
    local body = fixture:getBody()
    ent.x, ent.y = body:getPosition()
    
    if ent.vx or ent.vy then
        local vx, vy = body:getLinearVelocity()
        ent.vx, ent.vy = vx, vy
    end
end



on("update", function(dt)
    for _, ent in ipairs(physics_ents) do
        preUpdateEnt(ent)
    end
    world:update(dt)
    for _, ent in ipairs(physics_ents) do
        postUpdateEnt(ent)
    end
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


physics_ents:on_added(function(ent)
    if world:isLocked( ) then 
        error("World was locked! This is a bug on my behalf, sorry")  
    end

    local body = physics.newBody(world, ent.pos.x, ent.pos.y, getBodyType(ent))
    local fixture = physics.newFixture(body, ent.physics.shape)

    if ent.physics.friction then
        ent.physics.body:setLinearDamping(ent.physics.friction or DEFAULT_FRICTION)
    end

    fixture_to_ent[fixture] = ent
    ent_to_fixture[ent] = fixture
end)





physics_ents:on_removed(function(ent)
    local fixture = ent_to_fixture[ent]
    local body = fixture:getBody()
    fixture_to_ent[fixture] = nil
    ent_to_fixture[ent] = nil

    if not fixture:isDestroyed() then
        fixture:destroy()
    end

    if not body:isDestroyed() then
        body:destroy()
    end
    -- Dont need to destroy the shape, 
    -- as it is shared between all ent instances.
end)


