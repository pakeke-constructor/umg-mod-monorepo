

on("preDraw", function()
    graphics.clear(0.3,0.9,0.2)
end)


local control_ents = group("controllable", "inventory")

local isOpen = false

on("keypressed",function(k)
    if k == "e" then
        local player = control_ents[1]
        if player then
            isOpen = not isOpen
            player.inventory:setOpen(isOpen)
        end
    end
end)


