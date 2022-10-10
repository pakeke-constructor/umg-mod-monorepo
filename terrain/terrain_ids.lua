
--[[

terrain ids are dynamic at runtime.

]]

local max_terrain_id = 0





local terrainIds = {}


local terrainObjects = base.Set()

local id_to_terrainObj = {}
local terrainObj_to_id = {}



function terrainIds.generateId()
    max_terrain_id = max_terrain_id + 1
    return max_terrain_id
end




function terrainIds.setTerrainId(terrainObj, id)
    id_to_terrainObj[id] = terrainObj
    terrainObj_to_id[terrainObj] = id
end



function terrainIds.deleteTerrain(terrainObj)
    local id = terrainObj_to_id[terrainObj]
    assert(id,"?")
    terrainObj_to_id[terrainObj] = nil
    id_to_terrainObj[id] = nil
end



function terrainIds.getId(terrainObj)
    return id_to_terrainObj[terrainObj]
end








local terrainGroup = group("terrain")

terrainGroup:onAdded(function(ent)
    if ent.terrain then
        local id = terrainIds.generateId()
        terrainIds.setTerrainId(ent.terrain, id)
    end
end)




if server then

on("playerJoin", function(username)
    
end)

end




return terrainIds

