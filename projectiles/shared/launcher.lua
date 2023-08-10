

local launcherServer
if server then
    launcherServer = require("server.launcher")
end



--[[
    TODO:
    we should prolly change argument order for this event.
    Why should `holderEnt` be first?? does it even matter?
]]
umg.on("items:useItem", function(holderEnt, item, ...)
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        print("b1")
        return
    end
    if (not holderEnt.x) or (not holderEnt.y) then
        print("b2")
        return
    end

    print("here!")

    if item.projectileLauncher then
        print("here 2")
        if server then
            launcherServer.useItem(item, holderEnt, ...)
        elseif client then
            -- TODO: wtf do we do here?
            -- perhaps emit particles? provide api for playing sounds?
            -- Or we could just emit an event?
        end
    end
end)




