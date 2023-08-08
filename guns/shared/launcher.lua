




local function launchProjectileServer(holder_ent, item, ...)
    
end




function launchProjectileClient(holder_ent, item, ...)

end




umg.on("items:useItem", function(holderEnt, item, ...)
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        return
    end

    if item.projectileLauncher then
        if server then
            launchProjectileServer(holder_ent, item, ...)
        end
        if client then
            launchProjectileClient(holder_ent, item, ...)
        end
    end
end)




