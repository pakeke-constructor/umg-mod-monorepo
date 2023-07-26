

light.setBaseLighting(1,1,1)


weather.rain.setOptions({
    rainRate = 800,
    rainDrift = 0.1
})


vignette.setStrength(0.65)


base.client.groundTexture.setColor(
    {50/255, 100/255, 199/255}
--    {199/255, 140/255, 89/255}
)
base.client.groundTexture.setTextureList({"ground_texture_final4"})





love.graphics.clear()


local psys = base.client.particles.newParticleSystem({
    "circ4", "circ3", "circ2", "circ1"
})


base.client.particles.define("smoke", psys)


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



local listener = input.Listener({priority = 2})

function listener:keypressed(key, scancode, isrepeat)
    if scancode == "q" then
        local e = base.getPlayer()
        local x, y = rendering.getWorldMousePosition()
        base.client.particles.emit("smoke", e.x, e.y, 8, 10, {0.2,0.8,0.9})
        e.x = x
        e.y = y
        base.client.particles.emit("smoke", x, y, 8, 10)
    end
    if scancode == "y" then
        error("test")
    end
    if scancode == "space" then
        local e = base.getPlayer()
        if base.gravity.isOnGround(e) then
            e.vz = 400
        end
    end
end





umg.on("input", function(ent, inputEnum)
    if inputEnum == input.MOUSE_1 then
        items.useHoldItem(ent)
    end
end)


function listener:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local wx,wy = rendering.toWorldCoords(x,y)
        base.client.popups.text("Hello", wx, wy)
    elseif button == 2 then
        local wx,wy = rendering.toWorldCoords(x,y)
        client.send("spawn",wx,wy)
    end
end


