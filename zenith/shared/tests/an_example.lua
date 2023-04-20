
return function()
    -- runs code on server
    if server then
        server.broadcast("an_example_test", "hi")
    end

    local recvd = false

    -- runs code on client
    if client then
        client.on("an_example_test", function(msg)
            recvd = true
            zenith.assert(msg == "hi", "msg not hi")
        end)
    end

    -- waits 2 ticks, on both client AND server.
    zenith.tick(2)

    -- runs code on client again.
    if client then
        zenith.assert(recvd, "msg not recvd")
    end
end
