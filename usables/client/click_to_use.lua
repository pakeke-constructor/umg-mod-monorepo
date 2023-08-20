

local controllableGroup = umg.group("inventory", "controllable", "clickToUseItem")


local listener = input.Listener({priority = 2})


local function useItems()
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
            items.useHoldItem(ent)
        end
    end
end


function listener:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        useItems()
        self:lockMouseButton(button)
    elseif button == 2 then
        local wx,wy = rendering.toWorldCoords(x,y)
        client.send("spawn",wx,wy)
    end
end
