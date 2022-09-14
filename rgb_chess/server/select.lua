

local select = {}


local rgbTeamToSelected = {}

function select.select(rgbTeam, ent)
    assert(ent.squadron, "ent didnt have squadron: " .. ent:type())
    rgbTeamToSelected[rgbTeam] = ent.squadron
end




function select.getSelected(rgbTeam)
    local curr = rgbTeamToSelected[rgbTeam]
    if curr then
        for _, ent in ipairs(curr) do
            if not exists(ent)then
                curr = nil
                rgbTeamToSelected[rgbTeam] = nil
                break
            end
        end
    end
    return curr
end


return select

