
local rgb = {}

rgb.COLS = {
    RED = {1,0,0};
    GRN = {0,1,0};
    BLU = {0,0,1};

    YLO = {1,1,0};
    AQU = {0,1,1};
    MAG = {1,0,1};

    WHI = {1,1,1};

    BLK = {0,0,0};
}

setmetatable(rgb.COLS, {__index = function(_,k) error("invalid color: " .. tostring(k)) end})


local invert = {
    -- [{0,1,0}] = GRN
    -- ... etc 
}
for colName, val in pairs(rgb.COLS) do
    invert[val] = colName
end




function rgb.areMatchingColors(col1, col2)
    if exists(col1) and exists(col2) then
        local ent1, ent2 = col1, col2
        return rgb.areMatchingColors(ent1.rgb, ent2.rgb)
    end
    if not invert[col1] then
        error("invalid color for col1: " .. tostring(col1))
    end
    if not invert[col2] then
        error("invalid color for col2: " .. tostring(col2))
    end

    local r = col1[1]*col2[1]
    local g = col1[2]*col2[2]
    local b = col1[3]*col2[3]

    return (r+g+b) > 0
end




function rgb.getPVEEnemyTeam(rgbTeam)
    -- generates a team ID for use by PVE enemies
    return constants.PVE_PREFIX .. rgbTeam
end


function rgb.setTeam(ent, rgbTeam)
    --  sets a team for an entity
    if ent.rgbTeam ~= rgbTeam and ent.rgbTeam then
        error("Entity teams should be constant.")
    end
    ent.rgbTeam = rgbTeam
    categories.changeEntityCategory(ent, rgbTeam)
end


function rgb.setTarget(ent, rgbTeam)
    -- sets a target for an entity
    ent.moveBehaviourTargetCategory = rgbTeam
    ent.attackBehaviourTargetCategory = rgbTeam
end



function rgb.isRanged(ent)
    return ent.attackBehaviour and ent.attackBehaviour.type == "ranged"
end


function rgb.ipairs(rgbTeam)
    return categories.getSet(rgbTeam):ipairs()
end




_G.constants = require("shared.constants")



_G.rgb = rgb


