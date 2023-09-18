

local usage = require("shared.usage")


local controllableGroup = umg.group("inventory", "controllable", "clickToUseHoldItem")


local listener = input.Listener({priority = 2})


local function useItems(mode)
    local used = false
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
            local wasUsed = usage.useHoldItem(ent, mode)
            used = used or wasUsed
        end
    end
    return used
end



function listener:mousepressed(x, y, button, istouch, presses)
    local mode = button
    local used = useItems(mode)
    if used then
        -- only lock if an item was actually used
        self:lockMouseButton(button)
    end
end
