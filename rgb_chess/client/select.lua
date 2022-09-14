
local select = {}


local currentlySelected = nil

local selectedEnts = {
    --[ent] => true
}


function select.select(_, ent)
    currentlySelected = nil
    selectedEnts = {}
    assert(ent.squadron, "ent didnt have squadron: " .. ent:type())
    currentlySelected = ent.squadron
    for _, e in ipairs(currentlySelected) do
        selectedEnts[e] = true
    end
end



function select.deselect()
    currentlySelected = nil
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

on("drawEntity", function(ent)
    local t = timer.getTime()
    if selectedEnts[ent] then
        graphics.push("all")
        graphics.setColor(0,0,0)
        base.drawImage("target", ent.x, ent.y, t, 1.1,1.1)
        base.drawImage("target", ent.x, ent.y, t, 0.9,0.9)
        graphics.setColor(WHITE)
        base.drawImage("target", ent.x, ent.y, t)
        graphics.pop("all")
    end
end)


return select


