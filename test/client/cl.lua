

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
                if isOpen then
                    inv:open()
                else
                    inv:close()
                end
            end
        end
    end
end)




local psys = base.particles.newParticleSystem({
    "circ4", "circ3", "circ2", "circ1"
})


base.particles.define("smoke", psys)


on("keypressed", function(k)
    if k == "q" then
        local e = base.getPlayer()
        local x, y = base.camera:getMousePosition()
        base.particles.emit("smoke", e.x, e.y, 8, 10, {0.2,0.8,0.9})
        e.x = x
        e.y = y
        base.particles.emit("smoke", x, y, 8, 10)
    end
    if k == "c" then
        local e = base.getPlayer()
        base.particles.emit("smoke", e.x, e.y, 12, 10, {0.2,0.2,0.9})
    end
    if k =="r" then
        client.send("spawn", base.getPlayer())
    end
    if k == "f" then
        client.send("CONGLOMERATE", base.getPlayer())
        local ent = base.getPlayer()
        for _,e in ipairs(control_ents)do
            if e.controller == username then
                e.x = ent.x
                e.y = ent.y
            end
        end
    end
end)



on("mousepressed", function(x, y, button, istouch, presses)
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

    if button == 2 then
        local p = base.getPlayer()
        client.send("plzSpawn", p.x, p.y)
    end
end)

