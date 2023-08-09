

local launcher
if server then
    launcher = require("server.launcher")
end



--[[
    TODO:
    we should prolly change this argument order.
    Why should `holderEnt` be first?? does it even matter?
]]
umg.on("items:useItem", function(holderEnt, item, ...)
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        return
    end

    if item.projectileLauncher then
        if server then
            launchProjectileServer(holderEnt, item, ...)
        end
        if client then
            launchProjectileClient(holderEnt, item, ...)
        end
    end
end)




