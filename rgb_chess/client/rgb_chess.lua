

require("shared.rgb")


client.on("setRGBCameraBounds",function(x,y,w,h)
    base.camera:setBounds(x,y, w,h)
end)

