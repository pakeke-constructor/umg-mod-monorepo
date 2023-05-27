
local abilities = require("shared.abilities.abilities")

local levelAPI = {}



function levelAPI.getLevel(ent)
    return ent.level
end


function levelAPI.setLevel(ent, newLevel)
    local curLv = levelAPI.getLevel(ent)
    if curLv < newLevel then
        -- level up
        abilities.trigger("levelUp", ent.rgbTeam)
        umg.call("levelUp", ent, newLevel)
    elseif curLv > newLevel then
        -- level down
        abilities.trigger("levelDown", ent.rgbTeam)
        umg.call("levelDown", ent, newLevel)
    end
    -- else, we don't apply any triggers.
    ent.level = newLevel
end


function levelAPI.levelUp(ent, amount)
    levelAPI.setLevel(ent, levelAPI.getLevel(ent) + amount)
end


function levelAPI.levelDown(ent, amount)
    levelAPI.setLevel(ent, levelAPI.getLevel(ent) - amount)
end



return levelAPI

