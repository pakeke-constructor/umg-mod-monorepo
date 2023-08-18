
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


local WorldDimensionStructure = require("shared.world_dimension_structure")

local worldDimStruct = WorldDimensionStructure()



local strTc = typecheck.assert("string")



umg.on("dimensions:dimensionCreated", function(dimension, ent)
    worldDimStruct:createDimension(dimension)
end)


umg.on("dimensions:dimensionDestroyed", function(dimension, ent)
    worldDimStruct:destroyDimension(dimension)
end)



local function preUpdateEnt(ent)
    --[[
        Changes box2d body position if needed
    ]]
    local fixture = worldDimStruct:getFixture(ent)
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
    local fixture = worldDimStruct:getFixture(ent)
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

    worldDimStruct:updateWorlds(dt)

    for _, ent in ipairs(physicsGroup) do
        postUpdateEnt(ent)
    end
end)




umg.on("dimensions:entityMoved", function(ent, oldDim, newDim)
    if physicsGroup:has(ent) then
        worldDimStruct:entityMoved(ent, oldDim, newDim)
    end
end)




local allowedTypes = {
    kinematic = true; dynamic = true; static=true
}

local er1 = [[
Illegal physics.type value: %s
Must be one of the following:  "kinematic", "dynamic", or "static"
]]


local function checkPhysicsComponent(pc)
    if type(pc) ~= "table" then
        error("Physics component must be a table")
    end

    if pc.type and not allowedTypes[pc.type] then
        error(er1:format(tostring(pc.type)))
    end
end


physicsGroup:onAdded(function(ent)
    if (not ent.x) or (not ent.y) then
        error("Physics entities need x and y components.")
    end
    checkPhysicsComponent(ent.physics)

    worldDimStruct:addEntity(ent)
end)



umg.answer("xy:isFrictionDisabled", function(ent)
    -- physics entities shouldnt be bound by friction
    return ent.physics
end)





physicsGroup:onRemoved(function(ent)
    worldDimStruct:removeEntity(ent)
end)



function physics.getWorld(dimension)
    dimension = dimensions.getDimension(dimension)
    strTc(dimension)
    return worldDimStruct:getObject(dimension)
end



umg.expose("physics", physics)

