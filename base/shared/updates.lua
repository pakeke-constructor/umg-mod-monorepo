

--[[

implements `onUpdate` component.

Also implements preUpdate and postUpdate

]]


local updateGroup = umg.group("onUpdate")


umg.on("state:gameUpdate", function(dt)
    for _, ent in ipairs(updateGroup)do
        ent:onUpdate(dt)
    end
end)


