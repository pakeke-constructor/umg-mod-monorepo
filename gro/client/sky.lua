
--52.94% red, 80.78% green and 92.16% blue
local skyColor = {0.5, 0.9, 1}


-- TODO: Do we even want lighting for this mod?
-- We probably don't need it TBH


umg.on("preDraw", function()
    love.graphics.clear(skyColor)
end)



umg.on("inputPressed", function(inputEnum)
    if inputEnum == base.input.BUTTON_SPACE then
        local e = base.getPlayer()
        if base.gravity.isOnGround(e) then
            e.vz = 400
        end
    end
end)



