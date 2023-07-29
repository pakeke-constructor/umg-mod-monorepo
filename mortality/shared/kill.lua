
local kill

umg.defineEvent("mortality:entityDeath")


if server then
-- Only the server has the authority to kill entities.

function kill(ent)
    umg.call("mortality:entityDeath", ent)
    ent:delete()
end

end


sync.proxyEventToClient("mortality:entityDeath")



umg.on("mortality:entityDeath", function(ent)
    if ent.onDeath then
        ent:onDeath()
    end
end)



return kill
