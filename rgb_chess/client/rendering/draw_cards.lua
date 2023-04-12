



local function drawCard(ent)

end




umg.on("drawEntity", function(ent)
    if ent.cardBuyTarget then
        if rgb.state == rgb.STATES.TURN_STATE then
            drawCard(ent)
        end
    end
end)

