

--[[

implements `onUpdate` component.

]]


local updateGroup = umg.group("onUpdate")


umg.on("gameUpdate", function(dt)
    for _, ent in ipairs(updateGroup)do
        ent:onUpdate(dt)
    end
end)

