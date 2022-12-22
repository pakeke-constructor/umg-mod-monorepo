
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
    if not terrainObjects:has(terrainObj) then
        terrainObjects:add(terrainObj)
    end
end



function terrainIds.getTerrainObjects()
    return terrainObjects
end



function terrainIds.deleteTerrain(terrainObj)
    local id = terrainObj_to_id[terrainObj]
    assert(id,"?")
    terrainObj_to_id[terrainObj] = nil
    id_to_terrainObj[id] = nil
    terrainObjects:remove(terrainObj)
end



function terrainIds.getId(terrainObj)
    return terrainObj_to_id[terrainObj]
end

function terrainIds.getTerrainObject(id)
    return id_to_terrainObj[id]
end




local terrainGroup = umg.group("terrain")

terrainGroup:onAdded(function(ent)
    if ent.terrain and server then
        local id = terrainIds.generateId()
        terrainIds.setTerrainId(ent.terrain, id)
    end
end)




return terrainIds

