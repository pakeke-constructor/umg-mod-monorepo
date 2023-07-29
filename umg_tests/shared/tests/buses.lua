


return function()
    umg.defineEvent("ev", {hi = "hi"})
    umg.defineQuestion("my_question", {hi = "hi"})

    umg.call("ev")
    umg.ask("my_question", math.max)

    umg.answer("umg_tests:my_question", math.max)
    umg.on("umg_tests:ev", math.max)
end

