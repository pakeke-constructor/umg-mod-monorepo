
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




local COLS = rgb.COLS


local colorMatch = {
    [COLS.YLO] = {COLS.RED,COLS.GRN,COLS.AQU,COLS.MAG};
    [COLS.AQU] = {COLS.BLU,COLS.GRN,COLS.YLO,COLS.MAG};
    [COLS.MAG] = {COLS.RED,COLS.BLU,COLS.AQU,COLS.YLO};
}


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

    if (col1 == COLS.BLK) or (col2 == COLS.BLK) then
        return false
    end

    if col1 == col2 then
        return true
    end

    if col1 == COLS.WHI or col2 == COLS.WHI then
        return true
    end

    if colorMatch[col1] then
        local ar = colorMatch[col1]
        for i=1, #ar do
            if ar[i] == col2 then
                return true
            end
        end
    end
    return false
end



_G.rgb = rgb

