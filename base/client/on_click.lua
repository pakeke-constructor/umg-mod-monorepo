
local clickEnts = umg.group("x", "y", "onClick")






local listener = input.Listener({priority = 0})



function listener:mousepressed(mx, my, button, istouch, presses)
    -- TODO: This is kinda trash.
    -- this needs to be spatial partitioned probably.
    local worldX, worldY = rendering.toWorldCoords(mx, my)

    local bestDist = math.huge
    local bestEnt = nil

    for _, ent in ipairs(clickEnts) do
        local x, y = ent.x, rendering.getDrawY(ent.y, ent.z)
        local dist = math.distance(x-worldX, y-worldY)
        if dist < bestDist then
            if rendering.isHovered(ent) then
                bestEnt = ent
                bestDist = dist
            end
        end
    end

    if bestEnt then
        client.send("entityClicked", bestEnt, button, worldX, worldY)
        self:lockMouseButton(button)
    end
end



umg.defineEvent("entityClicked")


client.on("entityClicked", function(ent, username, button, worldX, worldY)
    umg.call("entityClicked", ent, username, button, worldX, worldY)
    if type(ent.onClick) == "function" then
        ent:onClick(username, button, worldX, worldY)
    end
end)




