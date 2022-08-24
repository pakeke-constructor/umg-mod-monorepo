

on("preDraw", function()
    graphics.clear(0.3,0.9,0.2)
end)



--[[
local frames = {}
for i=1,7 do
    table.insert(frames, "unit_card_rip" .. tostring(i))
end


-- TESTING:
on("keypressed", function(t)
    if t == "t" then
        local p = base.getPlayer()
        base.animate(frames, 0.5, 0,-10,0, nil, nil, p)
    end
end)
]]


