
--[[

using this code, the players can click to use an item.

]]


on("gameMousepressed", function(x, y, button, istouch, presses)
    if button == 1 then
        local p = base.getPlayer()
        if not p.inventory.isOpen then
            local item = p.inventory:getHoldingItem()
            if item and item.use then
                local mx, my = base.camera:getMousePosition()
                if item.itemHoldType == "place" then
                    item:use(mx,my)
                else
                    item:use(mx-p.x,my-p.y)
                end
            end
        end
    end
end)