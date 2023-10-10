
--[[
    this entity is used to test component projection!
    :)
]]
return {
    onClick = function(ent)
        if ent.animation then
            ent:removeComponent("animation")
            ent:removeComponent("image")
            return
        end
        if ent.image then
            ent.animation = {
                speed = 0.5,
                frames = {"spot_block", "slant_block"}
            }
            return
        end
        ent.image = "spot_block"
    end,
    size = 60,
    initXY = true
}

