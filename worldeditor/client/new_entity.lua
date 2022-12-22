


local newEntity = {}




local etypes = {}
local etypeList = {}

client.on("worldeditorSetETypes", function(etypes_)
    etypes = etypes_
    for etypeName, _ in pairs(etypes) do
        table.insert(etypeList, etypeName)
    end
end)



local selectedEType = nil


local function selectEType()
    --[[
        selecting entity to spawn.
    ]]
    if Slab.BeginComboBox('ETypeSelectCombo', {Selected = selectedEType}) then
        for _, etype in ipairs(etypeList) do
            if Slab.TextSelectable(etype) then
                selectedEType = etype
            end
        end
        Slab.EndComboBox()
    end    
end



local newEntityWindow = {
    Title = "World Editor",
    X = 100,
    Y = 100
}



local isOpen = true



umg.on("slabUpdate", function(dt)
    if not isOpen then 
        return
    end

	Slab.BeginWindow('EntityCreator', newEntityWindow)
    selectEType()

    if selectedEType then
        if Slab.Button("Create " .. selectedEType) then
            -- todo: move to server etc
            local e = server.entities[selectedEType](base.camera.x, base.camera.y)

        end
    end

	Slab.EndWindow()
end)




function newEntity.open()
    isOpen = true
end


function newEntity.close()
    isOpen = false
end




return newEntity
