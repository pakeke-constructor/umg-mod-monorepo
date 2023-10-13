
--[[

implements `updatable` component and `onUpdate` component.

]]


components.project("onUpdate", "updatable")

local updateGroup = umg.group("updateable")


umg.on("state:gameUpdate", function(dt)
    for _, ent in ipairs(updateGroup)do
        umg.call("state:entityUpdate", ent, dt)
    end
end)


umg.on("state:entityUpdate", function(ent, dt)
    if ent.onUpdate then
        ent:onUpdate(dt)
    end
end)

