

local openInventories = {}


local invArray = objects.Array()


function openInventories.open(inventory)
    assert(inventory ~= openInventories, "bad call")
    local foundI = invArray:find(inventory)
    if not foundI then
        invArray:add(inventory)
    end
end


function openInventories.close(inventory)
    assert(inventory ~= openInventories, "bad call")
    local i = invArray:find(inventory)
    if i then
        invArray:pop(i)
    end
end


function openInventories.getOpenInventories()
    return invArray
end



function openInventories.focus(inventory)
    -- Push this inventory to the top, so it's focused
    assert(inventory ~= openInventories, "bad call")
    if invArray[invArray:size()] == inventory then
        return -- its already focused
    end
    openInventories.close(inventory)
    openInventories.open(inventory)
end


return openInventories
