
--52.94% red, 80.78% green and 92.16% blue
local skyColor = {0.5, 0.9, 1}


-- TODO: Do we even want lighting for this mod?
-- We probably don't need it TBH
light.setBaseLighting(1,1,1)


on("preDraw", function()
    graphics.clear(skyColor)
end)

