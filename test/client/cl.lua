

on("preDraw", function()
    graphics.clear(0.3,0.9,0.2)
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
        base.animateEntity(base.getPlayer(), {"anvil1","anvil2","anvil3","anvil4"}, 1)
    end
    if k == "space" then
        local e = base.getPlayer()
        if base.gravity.isOnGround(e) then
            e.vz = 400
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
end)


