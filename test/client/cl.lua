

base.client.groundTexture.setDefaultGround({
    images = {"ground_texture_final4"},
    color = {0.3,0.9,0.55}
})




umg.on("@load", function()
    vignette.setStrength(0.65)

    base.client.groundTexture.setGround("overworld", {
        images = {"ground_texture_final4"},
        color = {0.7,0.7,0.7}
    })
end)





love.graphics.clear()


local psys = juice.particles.newParticleSystem({
    "circ4", "circ3", "circ2", "circ1"
})


juice.particles.define("smoke", psys)




local imgGroup = umg.group("x", "y", "image")

local spinning = false
client.on("spin", function()
    spinning = not spinning
end)

umg.on("state:gameUpdate", function(dt)
    if spinning then
        for _, ent in ipairs(imgGroup) do
            ent.rot = ent.rot or (math.random() * 6)
            ent.rot = ent.rot + dt*3
        end
    end
end)



local listener = input.Listener({priority = 2})


local DEFAULT_DIMENSION = dimensions.getDefaultDimension()


function listener:keypressed(key, scancode, isrepeat)
    if scancode == "q" then
        local e = control.getPlayer()
        local x, y = rendering.getWorldMousePosition()
        juice.particles.emit("smoke", e.x, e.y, 8, 10, {0.2,0.8,0.9})
        e.x = x
        e.y = y
        juice.particles.emit("smoke", x, y, 8, 10)
    end
    if scancode == "space" then
        local e = control.getPlayer()
        if base.gravity.isOnGround(e) then
            e.vz = 400
        end
    end
    if scancode == "y" then
        local cam = rendering.getCamera()
        local dim = DEFAULT_DIMENSION
        if cam:getDimension() == DEFAULT_DIMENSION then
            dim = "other"
        end
        client.send("swapdimension", dim)
        cam:setDimension(dim)
    end
end


umg.on("@draw", function()
    local p = control.getPlayer()
    if p then
        love.graphics.setColor(0,0,0)
        love.graphics.print(dimensions.getDimension(p))
    end
end)




local controllableGroup = umg.group("inventory", "clickToUseItems", "controllable")

local function useItems()
    for _, ent in ipairs(controllableGroup) do
        if ent.clickToUseItems then
            if sync.isClientControlling(ent) then
                items.useHoldItem(ent)
            end
        end
    end
end


function listener:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        useItems()
        self:lockMouseButton(button)
    end
end


