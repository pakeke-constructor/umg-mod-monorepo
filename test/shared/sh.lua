



chat.handleCommand("lighting", {
    adminLevel = 50,
    arguments = {{name = "level", type = "number"}},
    handler = function(sender, level)
        if client then
            light.setBaseLighting(level, level, level)
        end
    end
})


