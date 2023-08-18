
--[[


Object that holds all the physics worlds for each dimension.
(Each dimension gets it's own love.physics world)


]]

local DimensionWorlds = objects.Class("physics:DimensionWorlds", dimensions.DimensionStructure)




function DimensionWorlds:init()
    self:super()

    -- entity <--> fixture mappings
    self.fixture_to_ent = {}
    self.ent_to_fixture = {}
end



function DimensionWorlds:getEntity(fixture)
    return self.ent_to_fixture[fixture]
end


local function beginContact(self, fixture_A, fixture_B, contact_obj)
    local fixture_to_ent = self.fixture_to_ent
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]
    umg.call("physics:collide", ent_A, ent_B, contact_obj)
    umg.call("physics:collide", ent_B, ent_A, contact_obj)
    -- TODO: ^^^^ is this dumb????????
end


function DimensionWorlds:newObject()
    local world = love.physics.newWorld(0,0)

    local function beginContact1(fixture_A, fixture_B, contact_obj)
        -- must pass `self` as a closure. Hopefully jit can hoist
        return beginContact(self, fixture_A, fixture_B, contact_obj)
    end

    -- TODO: should we be using the other callbacks here???
    world:setCallbacks(beginContact1, nil, nil, nil)
    return world
end



function DimensionWorlds:destroyObject(world)
    world:destroy()
end



function DimensionWorlds:init()
    self:super()
end


