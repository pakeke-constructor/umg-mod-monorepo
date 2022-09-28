

--[[

implements `onUpdate` component.

]]


local updateGroup = group("onUpdate")


on("gameUpdate", function(dt)
    for _, ent in ipairs(updateGroup)do
        ent:onUpdate(dt)
    end
end)

