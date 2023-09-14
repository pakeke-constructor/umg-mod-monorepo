


return function()
    umg.defineEvent("umg_tests:ev")
    local add = function(x,y) return x+y end
    umg.defineQuestion("umg_tests:my_question", add)

    umg.answer("umg_tests:my_question", function(x)
        return x
    end)
    umg.answer("umg_tests:my_question", function(x)
        return x * 2
    end)

    umg.on("umg_tests:ev", math.max)

    zenith.assert(umg.ask("umg_tests:my_question", 3) == (3*2 + 3), "Expected 9")
    umg.call("umg_tests:ev", 1)
end

