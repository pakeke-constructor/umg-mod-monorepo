
return function()
    local N = 10
    zenith.clear()

    local appleGroup = umg.group("apple")

    if server then
        for _=1, N do
            local e = server.entities.empty()
            e.apple = "foo"
        end
    end

    zenith.assert(#appleGroup == 0, "apple group wasn't empty")

    zenith.tick(1)

    zenith.assert(#appleGroup == N, "apple group wasn't empty")

    if server then
        for _, e in ipairs(zenith.allGroup()) do
            e:removeComponent("apple")
        end
    end

    zenith.tick(1)
    
    zenith.assert(#appleGroup == 0, "apple group wasn't empty")
end
