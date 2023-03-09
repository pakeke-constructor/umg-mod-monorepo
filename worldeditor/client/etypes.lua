

local etypes = {
    entities = {},
    etypeList = {}
}


client.on("worldeditorSetEntityTypes", function(entities)
    etypes.entities = entities
    etypes.etypeList = base.Array()
    for etypeName, _ in pairs(entities) do
        etypes.etypeList:add(etypeName)
    end
end)



return etypes

