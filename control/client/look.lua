
--[[

Entities that are being controlled will automatically look at the mouse.

]]


local lookAtMouseGroup = umg.group("controllable", "lookAtMouse")


umg.on("@tick", function()
    for _, ent in ipairs(lookAtMouseGroup) do
        if sync.isClientControlling(ent) then
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

