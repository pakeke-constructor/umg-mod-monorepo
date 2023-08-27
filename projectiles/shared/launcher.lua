

local launcherServer
if server then
    launcherServer = require("server.launcher")
end



--[[
    TODO:
    we should prolly change argument order for this event.
    Why should `holderEnt` be first?? does it even matter?
]]
umg.on("usables:useItem", function(holderEnt, item, ...)
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        return
    end
    if (not holderEnt.x) or (not holderEnt.y) then
        return
    end

    if item.projectileLauncher then
        if server then
            launcherServer.useItem(item, holderEnt, ...)
        elseif client then
            -- TODO: wtf do we do here?
            -- perhaps emit particles? provide api for playing sounds?
            -- Or we could just emit an event?
        end
    end
end)




