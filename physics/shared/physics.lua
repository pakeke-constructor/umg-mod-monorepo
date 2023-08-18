
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



local constants = require("shared.constants")




local dimensionToWorld = {--[[
    [dimension] -> box2d world
]]}



local strTc = typecheck.assert("string")



umg.on("dimensions:dimensionCreated", function(dimension, ent)
    createPhysicsWorld(dimension)
end)


umg.on("dimensions:dimensionDestroyed", function(dimension, ent)
    destroyPhysicsWorld(dimension)
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



umg.on("state:gameUpdate", function(dt)
    for _, ent in ipairs(physicsGroup) do
        preUpdateEnt(ent)
    end

    for _dim, world in pairs(dimensionToWorld) do
        world:update(dt)
    end

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
        return "dynamic"
    end
end



local DEFAULT_SIZE = 16
local DEFAULT_SHAPE = love.physics.newCircleShape(DEFAULT_SIZE)


local function getShape(ent)
    if ent.physics.shape then
        return ent.physics.shape
    end

    return DEFAULT_SHAPE
end



local DEFAULT_FRICTION = constants.DEFAULT_FRICTION


local function addToPhysicsWorld(ent)
    local world = getPhysicsWorld(ent.dimension)
    if world:isLocked() then 
        error("World was locked! This is a bug on my behalf, sorry")  
    end
    if (not ent.x) or (not ent.y) then
        error("Physics entities need x and y components.")
    end
    local pc = ent.physics
    if type(pc) ~= "table" then
        error("Physics component must be a table")
    end

    local body = love.physics.newBody(world, ent.x, ent.y, getBodyType(ent))
    if pc.mass then
        body:setMass(pc.mass)
    end
    local fixture = love.physics.newFixture(body, getShape(ent))

    body:setLinearDamping(pc.friction or DEFAULT_FRICTION)

    fixture_to_ent[fixture] = ent
    ent_to_fixture[ent] = fixture
end



local function removeFromPhysicsWorld(ent)
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
end



umg.on("dimensions:entityMoved", function(ent, oldDim, newDim)
    if physicsGroup:has(ent) then
        removeFromPhysicsWorld(ent)
        addToPhysicsWorld(ent)
    end
end)






physicsGroup:onAdded(function(ent)
    addToPhysicsWorld(ent)
end)



umg.answer("xy:isFrictionDisabled", function(ent)
    -- physics entities shouldnt be bound by friction
    return ent.physics
end)





physicsGroup:onRemoved(function(ent)
    removeFromPhysicsWorld(ent)
end)



function physics.getWorld(dimension)
    dimension = dimensions.getDimension(dimension)
    strTc(dimension)
    return dimensionToWorld[dimension]
end



umg.expose("physics", physics)

