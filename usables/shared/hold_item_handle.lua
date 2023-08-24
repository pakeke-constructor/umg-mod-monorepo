

local extends = items.ItemHandle
local HoldItemHandle = objects.Class("usables:HoldItemHandle", extends)


function HoldItemHandle:onInvalidate(holderEnt, item)
    -- remove item position on invalidation:
    if item:hasComponent("x") then
        item:removeComponent("x")
    end

    if item:hasComponent("y") then
        item:removeComponent("y")
    end

    if item:hasComponent("dimension") then
        item:removeComponent("dimension")
    end

    umg.call("usables:unequipItem", item, holderEnt)
end


return HoldItemHandle

