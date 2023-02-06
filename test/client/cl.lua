

light.setBaseLighting(0.7,0.7,0.7)


base.groundTexture.setColor(0.3,0.9,0.2)
base.groundTexture.setTextureList({"ground_texture_final4"})





love.graphics.clear()


local psys = base.particles.newParticleSystem({
    "circ4", "circ3", "circ2", "circ1"
})


base.particles.define("smoke", psys)


--[[
umg.on("preDraw", function()
    love.graphics.clear(0.2,0.9,0.2)
end)
]]



local imgGroup = umg.group("x", "y", "image")

local spinning = false
client.on("spin", function()
    spinning = not spinning
end)

umg.on("update", function(dt)
    if spinning then
        for _, ent in ipairs(imgGroup) do
            ent.rot = ent.rot or (math.random() * 6)
            ent.rot = ent.rot + dt*3
        end
    end
end)






umg.on("keypressed", function(k)
    if k == "q" then
        local e = base.getPlayer()
        local x, y = base.camera:getMousePosition()
        base.particles.emit("smoke", e.x, e.y, 8, 10, {0.2,0.8,0.9})
        e.x = x
        e.y = y
        base.particles.emit("smoke", x, y, 8, 10)
    end
    if k =="r" and love.keyboard.isDown("lshift") then
        base.title("Thanks for watching!", {time = 2,fade=0.5})
        base.title("I hope you enjoyed it", {scale = 0.6, y=2/3, time=2.5, fade=0.5})
    end
    if k == "space" then
        local e = base.getPlayer()
        if base.gravity.isOnGround(e) then
            e.vz = 400
        end
    end
end)




umg.on("mousepressed", function(x, y, button, istouch, presses)
    if button == 1 then
        local p = base.getPlayer()
        if umg.exists(p) then
            items.useHoldItem(p)
        end
        local wx,wy = base.camera:toWorldCoords(x,y)
        base.shockwave(wx,wy,1,30,7,0.35)
    end
end)


