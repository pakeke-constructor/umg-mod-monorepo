
local READY_NAMETAG = "READY UP"

client.on("rgbReadyButton_setReadyFalse", function(ent)
    ent.rgb_is_ready = false
    ent.nametag.value = READY_NAMETAG
end)

