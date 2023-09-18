

local launcherServer
if server then
    launcherServer = require("server.launcher")
end




umg.on("usables:useItem", function(holderEnt, item, mode) 
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        return
    end
    if (not holderEnt.x) or (not holderEnt.y) then
        return
    end

    if item.shooter or item. then
        if server then
            launcherServer.useItem(holderEnt, item, mode)
        elseif client then
            -- TODO: wtf do we do here?
            -- perhaps emit particles? provide api for playing sounds?
            -- Or we could just emit an event?
        end
    end
end)




