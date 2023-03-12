

light.setBaseLighting(0.,0.,0.)


base.groundTexture.setColor(0.3,0.9,0.2)
base.groundTexture.setTextureList({"ground_texture_final4"})


rain.setOptions({
    rainRate = 1500,
    rainDrift = 0.11
})




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

umg.on("gameUpdate", function(dt)
    if spinning then
        for _, ent in ipairs(imgGroup) do
            ent.rot = ent.rot or (math.random() * 6)
            ent.rot = ent.rot + dt*3
        end
    end
end)



local listener = base.input.Listener({priority = 2})

function listener:keypressed(key, scancode, isrepeat)
    if scancode == "q" then
        local e = base.getPlayer()
        local x, y = base.camera:getMousePosition()
        base.particles.emit("smoke", e.x, e.y, 8, 10, {0.2,0.8,0.9})
        e.x = x
        e.y = y
        base.particles.emit("smoke", x, y, 8, 10)
    end
    if scancode == "space" then
        local e = base.getPlayer()
        if base.gravity.isOnGround(e) then
            e.vz = 400
        end
    end
end




function listener:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local p = base.getPlayer()
        if umg.exists(p) then
            items.useHoldItem(p)
        end
        local wx,wy = base.camera:toWorldCoords(x,y)
        base.shockwave({
            x = wx, y = wy, startRadius = 1, endRadius = 60, thickness = 20, duration = 0.55
        })
    elseif button == 2 then
        local wx,wy = base.camera:toWorldCoords(x,y)
        client.send("spawn",wx,wy)
    end
end


