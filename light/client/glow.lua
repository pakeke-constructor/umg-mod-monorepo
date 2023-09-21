


local DEFAULT_GLOW_IMG = "light_default_glow"




local DEFAULT_SIZE = 24


local function drawGlow(ent)
    love.graphics.push("all")
    local g = ent.glow
    local imgname = g.image or DEFAULT_GLOW_IMG
    local glow_quad = client.assets[imgname]
    if not glow_quad then
        error("Unknown image for glow: " .. tostring(imgname))
    end

    local size = g.size or DEFAULT_SIZE
    local scale = size / DEFAULT_SIZE
    rendering.drawImage(glow_quad, ent.x, ent.y, ent.rot, scale, scale)
    love.graphics.pop()
end


umg.on("rendering:postDrawEntity", function(ent)
    if ent.glow then
        drawGlow(ent)
    end
end)
