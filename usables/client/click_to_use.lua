

local usage = require("shared.usage")


local controllableGroup = umg.group("inventory", "controllable", "clickToUseHoldItem")


local listener = input.Listener({priority = 2})


local function useItems(mode)
    for _, ent in ipairs(controllableGroup) do
        if sync.isClientControlling(ent) then
            usage.useHoldItem(ent, mode)
        end
    end
end


function listener:mousepressed(x, y, button, istouch, presses)
    local mode = button
    useItems(mode)
    self:lockMouseButton(button)
end
