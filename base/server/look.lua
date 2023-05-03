
--[[
automatic syncing for entity look directions

lookX and lookY
]]



local lookGroup = umg.group("lookX", "lookY")


local sf = sync.filters

server.on("setLookDirection", {
    arguments = {sf.entity, sf.number, sf.number},
    handler = function(sender, ent, lookX, lookY)
        if ent.controller == sender then
            ent.lookX = lookX
            ent.lookY = lookY
        end
    end
})




umg.on("@tick", function()
    for _, ent in ipairs(lookGroup) do
        -- TODO: delta compression
        server.broadcast("setLookDirection", ent, ent.lookX, ent.lookY)
    end
end)



