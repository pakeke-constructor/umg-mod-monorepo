
--[[

    lifetime component

]]



-- make sure component is synced to clients.
sync.autoSyncComponent("lifetime", {
    lerp = true
})




if server then


local lifetimeGroup = umg.group("lifetime")

local kill = require("shared.kill")




umg.on("state:gameUpdate", function(dt)
    for ent in ipairs(lifetimeGroup) do
        ent.lifetime = ent.lifetime - dt

        if ent.lifetime <= 0 then
            kill(ent)
        end
    end
end)


end
