
local buy = {}


function buy.sellSquadron(ent)
    client.send("sellSquadron", ent)
end


return buy

