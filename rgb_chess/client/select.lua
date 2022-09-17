
local select = {}


local BLACK = {0,0,0}


local currentlySelected = nil
local currentlySelectedRGB = BLACK
local selectedEnts = {
    --[ent] => true
}


function select.select(_, ent)
    currentlySelected = nil
    currentlySelectedRGB = ent.rgb
    selectedEnts = {}
    assert(ent.squadron, "ent didnt have squadron: " .. ent:type())
    currentlySelected = ent.squadron
    for _, e in ipairs(currentlySelected) do
        selectedEnts[e] = true
    end
end




function select.deselect()
    currentlySelected = nil
    currentlySelectedRGB = BLACK
    selectedEnts = {}
end



function select.getSelected()
    if currentlySelected then
        for _, ent in ipairs(currentlySelected) do
            if not exists(ent)then
                currentlySelected = nil
                selectedEnts = {}
                break
            end
        end
    end
    return currentlySelected
end



local WHITE = {1,1,1}
local SAMECOL_OPACITY = 0.95

on("drawEntity", function(ent)
    if ent.rgb then
        if selectedEnts[ent] then
            local t = timer.getTime()
            graphics.push("all")
            graphics.setColor(0,0,0)
            base.drawImage("target", ent.x, ent.y, t, 1.1,1.1)
            base.drawImage("target", ent.x, ent.y, t, 0.9,0.9)
            graphics.setColor(WHITE)
            base.drawImage("target", ent.x, ent.y, t)
            graphics.pop("all")
        elseif rgb.areMatchingColors(ent.rgb, currentlySelectedRGB) then
            local t = timer.getTime()
            graphics.push("all")
            local c = ent.color
            graphics.setColor(c[1],c[2],c[3],SAMECOL_OPACITY)
            base.drawImage("target", ent.x, ent.y, t, 1.2,1.2)
            graphics.pop("all")
        end
    end
end)


return select


