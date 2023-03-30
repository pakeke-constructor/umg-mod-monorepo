

local breakFrames = {}
for i=1,7 do
    table.insert(breakFrames, "unit_card_rip" .. tostring(i))
end



client.on("rerollCard", function(card_ent)
    -- play sound here!
    base.client.animate(breakFrames, constants.REROLL_TIME, card_ent.x, card_ent.y, card_ent.z, card_ent.color)
end)



