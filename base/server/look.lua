
--[[
automatic syncing for entity look directions

lookX and lookY
]]



local lookGroup = umg.group("lookX", "lookY")


local sf = sync.filters

server.on("setLookDirection", {
    arguments = {sf.entity, sf.number, sf.number},
    hander = function(sender, ent, lookX, lookY)
        if not umg.exists(ent) then return end
        if type(lookX) ~= "number" then return end
        if type(lookY) ~= "number" then return end
        
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



