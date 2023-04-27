
local itemPool = {}



local itemRGBSelection = base.weightedRandom({
    -- [result]    =  probability weight
    -- Composite colors are more common on items.
    [rgb.COLS.RED] =   0.3,
    [rgb.COLS.BLU] =   0.3,
    [rgb.COLS.GRN] =   0.3,
    [rgb.COLS.YLO] =   0.2,
    [rgb.COLS.MAG] =   0.2,
    [rgb.COLS.AQU] =   0.2,
})





local rawRandom

umg.on("@load", function()
    -- We have to do this within the load function,
    -- because entities aren't loaded yet.
    local etypeToRarity = {}

    for _, etype in pairs(server.entities)do
        if etype.itemInfo then
            -- its an item, add it to item pool
            etypeToRarity[etype] = etype.itemInfo.rarity or constants.DEFAULT_RARITY
        end
    end

    rawRandom = base.weightedRandom(etypeToRarity)
end)



local MAX_ITER = 100

local function randomItemEType(turn)
    local itemEType = rawRandom()
    local ct = 1
    while ct < MAX_ITER and (itemEType.itemInfo.minimumTurn or 1) > turn do 
        itemEType = rawRandom()
        ct = ct + 1
    end
    return itemEType
end




function itemPool.randomItem(board, x, y)
    local rgbTeam = board:getTeam()
    local turn = rgb.getTurn()
    local etype = randomItemEType(turn)
    local ent = etype()
    ent.rgb = itemRGBSelection()
    ent.rgbTeam = rgbTeam
    items.drop(ent, x, y)
end



return itemPool

