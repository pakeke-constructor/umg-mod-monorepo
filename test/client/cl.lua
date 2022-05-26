

on("preDraw", function()
    graphics.clear(0.3,0.9,0.2)
end)


local control_ents = group("controllable", "inventory")

local isOpen = false


on("keypressed",function(k)
    if k == "e" then
        isOpen = not isOpen
        for i,ent in ipairs(control_ents)do
            local inv = ent.inventory
            inv:setOpen(isOpen)
        end
    end
end)


