

umg.on("@entityInit", function(ent)
    --[[
        TODO: Should we remove this...???
        It's a tiny bit bloat-y, im not gonna lie.

        Perhaps rename this to `ent.initControl` or something,
        and have it add `moveX, moveY` components too...?
        Do some thinking.
    ]]
    if ent.initLook then
        ent.lookX = ent.x or 0
        ent.lookY = ent.y or 0
    end
end)

