
local select = {}


local BLACK = {0,0,0}


local currentlySelected = nil
local currentlySelectedRGB = BLACK
local selectedEnts = {
    --[ent] => true
}


function select.select(ent)
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
            if not umg.exists(ent)then
                select.deselect()
                break
            end
        end
    end
    return currentlySelected
end


function select.isSelected(ent)
    if selectedEnts then
        return selectedEnts[ent]
    end
end


function select.getSelectedRGB()
    return currentlySelectedRGB
end


umg.on("gameUpdate", function()
    for ent,_ in pairs(selectedEnts) do
        if not umg.exists(ent) then
            select.deselect()
            break
        end
    end
end)



umg.on("gameMousepressed", function(x,y, button)
    -- right click to deselect
    if button == 2 then
        select.deselect()
    end
end)



return select


