
local terrainGroup = umg.group("x","y","terrain")


terrainGroup:onAdded(function(ent)
    assert(ent.terrain, "Entity not given terrain value!")
    ent.terrain:bindEntity(ent)
end)


