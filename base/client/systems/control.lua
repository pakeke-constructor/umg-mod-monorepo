
--[[

Handles player control


PLANNING::::
How are we going to do controls?
It's probably best to set controls outside of the mod, i.e. have an
explicit ui menu that allows the user to change the controls


]]

local control_ents = group("controllable")



on("keypressed", function(key, scancode)

end)


on("keyreleased", function(key, scancode)

end)




on("update", function(dt)
    for _, ent in ipairs(control_ents) do
        
    end
end)

