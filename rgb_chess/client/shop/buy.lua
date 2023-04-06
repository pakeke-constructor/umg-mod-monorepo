

client.on("setRGBCardCost", function(card, cost)
    card.cost = cost
end)


client.on("buyUnitSquadron", function(squadron)

end)


local buy = {}



function buy.sellSquadron(ent)
    client.send("sellSquadron", ent)
end


return buy

