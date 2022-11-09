

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
        client.send("spawn",base.getPlayer())
    end
    if k =="r" then
        base.title("Title!", {time = 2,fade=0.5})
        base.title("subtitle!", {scale = 0.6, y=2/3, time=2.5, fade=0.5})
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
        if p and (not p.inventory.isOpen) then
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


