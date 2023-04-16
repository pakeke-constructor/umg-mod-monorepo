

local BOX_W, BOX_H = 18,18

-- Drawing within world
umg.on("drawEntity", function(ent)
    if ent.itemName and ent.rgb then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(ent.rgb)
        local x,y = ent.x - BOX_W/2, ent.y - BOX_H/2
        love.graphics.rectangle("line", x,y, BOX_W, BOX_H)
    end
end)



-- Drawing within inventory
umg.on("drawInventoryItem", function(ent, itemEnt, drawX, drawY, slotSize)
    if itemEnt.rgb then
        local w,h = slotSize - 1, slotSize - 1
        love.graphics.setLineWidth(2)
        love.graphics.setColor(itemEnt.rgb)
        local x,y = drawX - w/2, drawY - h/2
        love.graphics.rectangle("line", x,y, w, h)
    end
end)


