


return function()
    umg.defineEvent("umg_tests:ev", {hi = "hi"})
    umg.defineQuestion("umg_tests:my_question", {hi = "hi"})

    umg.answer("umg_tests:my_question", math.max)
    umg.on("umg_tests:ev", math.max)
end

