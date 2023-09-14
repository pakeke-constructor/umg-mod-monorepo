
--[[
    Testing broadcast functionality
]]


local function mustBe2(x)
    return x == 2
end

local function mustBeString(x)
    return type(x) == "string"
end



return function()
    local recvd = false

    if client then
        client.on("an_example_test", function(msg)
            recvd = true
            zenith.assert(msg == "hi", "msg not hi")
        end)
    end

    zenith.tick()

    if server then
        server.broadcast("an_example_test", "hi")
    end

    zenith.tick(2)

    if client then
        zenith.assert(recvd, "msg not recvd")
    end



    --[[
        testing client --> server events,
        and validation
    ]]
    local aRecv, bRecv

    if server then
        server.on("send_to_server", {
            arguments = {mustBeString, mustBe2},
            handler = function(sender, a, b)
                aRecv, bRecv = a, b
            end
        })
    end

    zenith.tick()

    -- test that we aren't receiving packets:
    if client then
        client.send("send_to_server", 1, 3)
    end
    zenith.tick()
    zenith.assert(not (aRecv or bRecv), "recieved invalid packet 1")
    zenith.tick()

    -- test that we aren't receiving packets:
    if client then
        client.send("send_to_server", "hiii", 2.1)
    end
    zenith.tick()
    zenith.assert(not (aRecv or bRecv), "recieved invalid packet 2")
    zenith.tick()

    -- test that we aren't receiving packets:
    local str = "all goods"
    if client then
        aRecv, bRecv = str, 2
        client.send("send_to_server", aRecv, bRecv)
    end
    zenith.tick(2)
    zenith.assert(aRecv==str and bRecv==2, "Didn't pick up packet even tho valid")
    zenith.tick()
end

