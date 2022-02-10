
local i = 1


on("keypressed", function(k)
    client.send(k, i)
    i = i + 1
end)


