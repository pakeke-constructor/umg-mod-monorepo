
--[[


Is an object


]]

local DimensionWorlds = objects.Class("physics:DimensionWorlds", dimensions.DimensionObject)


local fixture_to_ent = {}
local ent_to_fixture = {}


local instantiated = false

function DimensionWorlds:init()
    self:super()

    assert(not instantiated, "This object is a singleton")
    instantiated = true
end




local function beginContact(fixture_A, fixture_B, contact_obj)
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]
    umg.call("physics:collide", ent_A, ent_B, contact_obj)
    umg.call("physics:collide", ent_B, ent_A, contact_obj)
    -- TODO: ^^^^ is this dumb????????
end


function DimensionWorlds:newObject()
    local world = love.physics.newWorld(0,0)
    -- TODO: should we be using the other callbacks here???
    world:setCallbacks(beginContact, nil, nil, nil)
    return world
end


function DimensionWorlds:destroyObject(world)
    world:destroy()
end



function DimensionWorlds:init()
    self:super()
end







