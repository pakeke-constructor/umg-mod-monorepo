

local kill


if server then

function kill(ent)
    umg.call("entityDeath", ent)
    ent:delete()
end

end


sync.proxyEventToClient("entityDeath")



umg.on("entityDeath", function(ent)
    if ent.onDeath then
        ent:onDeath()
    end
end)



return kill

