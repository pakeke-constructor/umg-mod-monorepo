
local abilities = require("shared.abilities.abilities")
local Board = require("server.board")

local levelAPI = {}



function levelAPI.getLevel(ent)
    return ent.level or 1
end

local entNumberTc = typecheck.assert("entity", "number")

function levelAPI.setLevel(ent, newLevel)
    entNumberTc(ent, newLevel)
    local curLv = levelAPI.getLevel(ent)
    if curLv < newLevel then
        -- level up
        abilities.trigger("allyLevelUp", ent.rgbTeam)
        umg.call("levelUp", ent, newLevel)
    elseif curLv > newLevel then
        -- level down
        abilities.trigger("allyLevelDown", ent.rgbTeam)
        umg.call("levelDown", ent, newLevel)
    end
    -- else, we don't apply any triggers.
    ent.level = newLevel
end


function levelAPI.levelUp(ent, amount)
    entNumberTc(ent, amount)
    levelAPI.setLevel(ent, levelAPI.getLevel(ent) + amount)
end


function levelAPI.levelDown(ent, amount)
    entNumberTc(ent, amount)
    levelAPI.setLevel(ent, levelAPI.getLevel(ent) - amount)
end



umg.on("startTurn", function()
    for _rgbTeam, board in Board.iterBoards() do
        local units = board:getUnits()
        for _, ent in ipairs(units)do
            levelAPI.levelUp(ent, 1)
        end
    end
end)



return levelAPI

