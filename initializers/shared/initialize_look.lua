

umg.on("@entityInit", function(ent)
    if ent.initLook then
        ent.lookX = ent.x or 0
        ent.lookY = ent.y or 0
    end
end)

