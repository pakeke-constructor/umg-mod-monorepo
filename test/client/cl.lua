

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
end)



