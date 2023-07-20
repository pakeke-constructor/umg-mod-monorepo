
base.client.groundTexture.setColor({199/255, 140/255, 89/255})
base.client.groundTexture.setTextureList({"ground_texture"})



require("shared.rgb")


client.on("rgbEmplacePlayer",function(x,y,w,h)
    rendering.getCamera():setBounds(x,y, w,h)
end)



client.on("setupPvPMatch", function(opponent)
    -- TODO: Play a sound here,  change music, etc.

    local p = base.getPlayer()
    if p then
        base.client.shockwave(p.x, p.y, 10, 600, 10, 0.6)
    end

    base.client.title("PvP Start", {
        x = 1/2, y = 1/2,
        color = {1,1,1},
        fade = 0.6,
        time = 3,
        scale = 2
    })

    base.client.title("Opponent: " .. opponent, {
        x = 1/2, y = 2/3,
        color = {1,0.2,0.2},
        fade = 0.5,
        time = 3.5,
        scale = 0.8
    })
end)



