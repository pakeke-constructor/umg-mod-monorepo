
require("physics_events")


local physicsGroup = umg.group("physics", "x", "y")

--[[

Handles all entities that need physics in the game.


TODO: 
We should really look into using question buses inside of
world:setCallbacks(...) to determine whether a collision goes
through or not.
I think there's a way to turn collisions on/off, but I'm not sure.


]]

local physics = {}



local fixture_to_ent = {}
local ent_to_fixture = {}


local constants = require("shared.constants")




local function beginContact(fixture_A, fixture_B, contact_obj)
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]
    umg.call("physics:collide", ent_A, ent_B, contact_obj)
    umg.call("physics:collide", ent_B, ent_A, contact_obj)
end


local world

local function newWorld()
    if world then
        world:destroy()
    end
    world = love.physics.newWorld(0,0)
    --[[
        TODO: should we be using the other callbacks here???
    ]]
    world:setCallbacks(beginContact, nil, nil, nil)
end


newWorld() -- The box2d physics world used by entities



--[[
    : Must be changed when dimensions mod is made!
]]
umg.on("@createWorld", newWorld)



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



umg.on("state:gameUpdate", function(dt)
    for _, ent in ipairs(physicsGroup) do
        preUpdateEnt(ent)
    end
    world:update(dt)
    for _, ent in ipairs(physicsGroup) do
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



local DEFAULT_FRICTION = constants.DEFAULT_FRICTION


physicsGroup:onAdded(function(ent)
    if world:isLocked( ) then 
        error("World was locked! This is a bug on my behalf, sorry")  
    end
    if (not ent.x) or (not ent.y) then
        error("Physics entities must be given x and y values upon creation.")
    end

    local body = love.physics.newBody(world, ent.x, ent.y, getBodyType(ent))
    local fixture = love.physics.newFixture(body, ent.physics.shape)

    body:setLinearDamping(ent.physics.friction or DEFAULT_FRICTION)

    fixture_to_ent[fixture] = ent
    ent_to_fixture[ent] = fixture
end)





physicsGroup:onRemoved(function(ent)
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



function physics.getWorld()
    return world
end


umg.expose("physics", physics)

