

local followGroup = umg.group("followEntity")


--[[


TODO: Make this way better.

Currently, strong ownership is done.
This is dumb.
Look at the EntityRef ticket in trello.
We probably want to do ephemeral components with `_`.


]]

umg.on("@tick", function()
    for _, ent in ipairs(followGroup) do
        local e = ent.followEntity
        if e.x and e.y then
            ent.moveX = e.x
            ent.moveY = e.y
        end
    end
end)


