

on("preDraw", function()
    graphics.clear(0.3,0.9,0.2)
end)


local control_ents = group("controllable", "inventory")

local isOpen = false

on("keypressed",function(k)
    if k == "e" then
        isOpen = not isOpen
        for i,ent in ipairs(control_ents) do
            if username == ent.controller then
                local inv = ent.inventory
                inv:setOpen(isOpen)
            end
        end
    end

    if k == "p" then
        for i,ent in ipairs(control_ents) do
            if username == ent.controller then
                client.send("spawnPlayer", ent.x, ent.y)
            end
        end
    end
end)


