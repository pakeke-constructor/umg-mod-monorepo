

local etypes = {
    entities = {},
    etypeList = {}
}


client.on("worldeditorSetEntityTypes", function(entities)
    etypes.entities = entities
    etypes.etypeList = {}
    for etypeName, ctor in pairs(entities) do
        etypes.etypeList[etypeName] = ctor
    end
end)



return etypes
