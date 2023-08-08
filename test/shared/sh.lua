



chat.handleCommand("lighting", {
    adminLevel = 50,
    arguments = {{name = "level", type = "number"}},
    handler = function(sender, level)
        if client then
            light.setBaseLighting(level, level, level)
        end
    end
})




local spinning = false

if client then

umg.answer("rendering:getRotation", function(e)
    -- if we are spinning, then return a rotation rate
    if spinning then
        return state.getGameTime() + (e.id / 5)
    end
end)

end




chat.handleCommand("spin", {
    adminLevel = 50,
    arguments = {},
    handler = function(sender)
        if client then
            spinning = true
            scheduling.delay(4, function()
                spinning = false
            end)
        end
    end
})


