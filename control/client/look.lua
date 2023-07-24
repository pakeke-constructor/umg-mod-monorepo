
--[[
automatic syncing for entity look directions

lookX and lookY
]]



local lookGroup = umg.group("controller", "lookAtMouse")


--[[

todo:

we need to get rid of this, 
and replace it with sync.autoSyncComponent

]]


client.on("setLookDirection", function(ent, lookX, lookY)
    if ent.controller == client.getUsername() then
        return -- we have more up to date data
    end
    ent.lookX = lookX
    ent.lookY = lookY
end)




umg.on("@tick", function()
    for _, ent in ipairs(lookGroup) do
        if ent.controller == client.getUsername() then
            if ent.lookAtMouse then
                local lx, ly = rendering.getWorldMousePosition()
                ent.lookX, ent.lookY = lx, ly
            else
                ent.lookX, ent.lookY = nil, nil
            end

            -- TODO: delta compression
            client.send("setLookDirection", ent, ent.lookX, ent.lookY)
        end
    end
end)

