
--[[

lua files in client/ are automatically loaded on clientside.

]]

umg.on("keypressed", function(key)
    client.send("key_pressed") -- send msg to server
end)

