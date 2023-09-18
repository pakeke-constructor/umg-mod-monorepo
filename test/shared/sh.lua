



chat.handleCommand("lighting", {
    adminLevel = 50,
    arguments = {
        {name = "dimension", type = "string"},
        {name = "r", type = "number"},
        {name = "g", type = "number"},
        {name = "b", type = "number"},
    },
    handler = function(sender, dimension, r,g,b)
        if client then
            local dim = dimensions.getDimension(dimension)
            light.setLighting(dim, r,g,b)
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



local dtMod = 1

chat.handleCommand("dt", {
    adminLevel = 50,
    arguments = {{
        type = "number",
        name = "dt"
    }},
    handler = function(sender, a)
        dtMod = a
    end
})


umg.answer("state:getDeltaTimeMultiplier", function()
    return dtMod
end)

