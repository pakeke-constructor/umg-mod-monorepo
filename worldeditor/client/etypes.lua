

local etypes = {
    entities = {},
    etypeList = {}
}



client.on("worldeditorSetEntityTypes", function(entities)
    etypes.entities = entities
    etypes.etypeList = objects.Array()
    for etypeName, _ in pairs(entities) do
        etypes.etypeList:add(etypeName)
    end
    table.sort(etypes.etypeList)
end)



return etypes

