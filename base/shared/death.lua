

local kill


if server then

function kill(ent)
    umg.call("entityDeath", ent)
    server.broadcast("entityDeath", ent)
    ent:delete()
end

elseif client then

client.on("entityDeath", function(ent)
    umg.call("entityDeath", ent)
end)

end








umg.on("entityDeath", function(ent)
    if ent.onDeath then
        ent:onDeath()
    end
end)



return kill

