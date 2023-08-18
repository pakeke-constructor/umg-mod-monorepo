
--[[


Object that holds all the physics worlds for each dimension.
(Each dimension gets it's own love.physics world)


Inherits from DimensionStructure.


]]

local WorldDimensionStructure = objects.Class("physics:WorldDimensionStructure", dimensions.DimensionStructure)


local constants = require("shared.constants")




function WorldDimensionStructure:init()
    self:super()

    -- entity <--> fixture mappings
    self.fixture_to_ent = {}
    self.ent_to_fixture = {}
end



function WorldDimensionStructure:getEntity(fixture)
    return self.fixture_to_ent[fixture]
end


function WorldDimensionStructure:getFixture(ent)
    return self.ent_to_fixture[ent]
end



function WorldDimensionStructure:updateWorlds(dt)
    -- updates all box2d worlds
    for _dim, world in pairs(self.dimensionToObject) do
        world:update(dt)
    end
end



local function beginContact(self, fixture_A, fixture_B, contact_obj)
    local fixture_to_ent = self.fixture_to_ent
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]
    umg.call("physics:collide", ent_A, ent_B, contact_obj)
    umg.call("physics:collide", ent_B, ent_A, contact_obj)
    -- TODO: ^^^^ is this dumb????????
end


function WorldDimensionStructure:newObject(_dimension)
    local world = love.physics.newWorld(0,0)

    local function beginContact1(fixture_A, fixture_B, contact_obj)
        -- we need to pass `self` as a closure. jit will prolly hoist anyway
        return beginContact(self, fixture_A, fixture_B, contact_obj)
    end

    -- TODO: should we be using the other callbacks here???
    world:setCallbacks(beginContact1, nil, nil, nil)
    return world
end




function WorldDimensionStructure:addEntityToObject(world, ent)
    local pc = ent.physics

    local bodyType = pc.type or constants.DEFAULT_BODY_TYPE
    local shape = pc.shape or constants.DEFAULT_SHAPE

    local body = love.physics.newBody(world, ent.x, ent.y, bodyType)
    if pc.mass then
        body:setMass(pc.mass)
    end
    local fixture = love.physics.newFixture(body, shape)

    body:setLinearDamping(pc.friction or constants.DEFAULT_FRICTION)

    self.fixture_to_ent[fixture] = ent
    self.ent_to_fixture[ent] = fixture
end



function WorldDimensionStructure:removeEntityFromObject(_world, ent)
    local fixture = self:getFixture(ent)
    local body = fixture:getBody()
    self.fixture_to_ent[fixture] = nil
    self.ent_to_fixture[ent] = nil

    if not fixture:isDestroyed() then
        fixture:destroy()
    end

    if not body:isDestroyed() then
        body:destroy()
    end
    -- Dont need to destroy the shape, 
    -- as it is shared between all ent instances.
end



function WorldDimensionStructure:destroyObject(world)
    world:destroy()
end



return WorldDimensionStructure
