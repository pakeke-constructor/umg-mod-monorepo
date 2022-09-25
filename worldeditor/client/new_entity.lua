


local newEntity = {}


local newEntityWindow = {
    Title = "World Editor",
    X = 100,
    Y = 100
}


local isOpen = true


function newEntity.update()
    if not isOpen then 
        return
    end

	Slab.BeginWindow('EntityCreator', newEntityWindow)

    if Slab.Button("new entity") then
        print("hello")
    end

    --[[
    local x,y = Slab.GetWindowPosition()
    if x and y then
        newEntityWindow.X, newEntityWindow.Y = x,y
    end
    ]]
	Slab.EndWindow()
end


function newEntity.open()
    isOpen = true
end

function newEntity.close()
    isOpen = false
end



return newEntity


