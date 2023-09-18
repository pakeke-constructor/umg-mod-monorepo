

local shooterServer
if server then
    shooterServer = require("server.shooter")
end




umg.on("usables:useItem", function(holderEnt, item, mode) 
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        return
    end
    if (not holderEnt.x) or (not holderEnt.y) then
        return
    end

    if item.shooter then
        if server then
            shooterServer.useItem(holderEnt, item, mode)
        elseif client then
            -- TODO: wtf do we do here?
            -- perhaps emit particles? provide api for playing sounds?
            -- Or we could just emit an event?
        end
    end
end)




