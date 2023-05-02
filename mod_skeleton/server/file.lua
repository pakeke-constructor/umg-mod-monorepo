
--[[

lua files in server/ are automatically loaded on server-side.

]]

server.on("key_pressed", {
    arguments = {},
    handler = function(sender, key)
        -- listen to messages from the client
        print("key pressed from client: ", sender, "with key: ", tostring(key))
    end
})

