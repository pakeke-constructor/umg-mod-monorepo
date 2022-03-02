

on("preDraw", function()
    graphics.clear(0.2,0.9,0.1)
end)


local control_ents = group("controllable")

on("keypressed", function(key)
    if key == "space" then
        for _, ent in ipairs(control_ents) do
            if ent.color ~= nil then
                ent.color = {0.7,0.1,0}
            end
        end
    end
end)



