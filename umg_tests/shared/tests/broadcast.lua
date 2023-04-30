
--[[
    Testing broadcast functionality
]]
return function()
    if server then
        server.broadcast("an_example_test", "hi")
    end

    local recvd = false

    if client then
        client.on("an_example_test", function(msg)
            recvd = true
            zenith.assert(msg == "hi", "msg not hi")
        end)
    end

    zenith.tick(2)

    if client then
        zenith.assert(recvd, "msg not recvd")
    end
end

