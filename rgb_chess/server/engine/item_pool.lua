
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
do
local etypeToRarity = {}

for _, etype in pairs(server.entities)do
    if etype.itemInfo then
        -- its an item, add it to item pool
        etypeToRarity[etype] = etype.itemInfo.rarity or constants.DEFAULT_RARITY
    end
end

rawRandom = base.weightedRandom(etypeToRarity)
end




local function randomItemEType(turn)
    local itemEType = rawRandom()
    while (itemEType.itemInfo.minimumTurn or 1) > turn do 
        itemEType = rawRandom()
    end
    return itemEType
end




function itemPool.randomItem(rgbTeam)
    local turn = rgb.getTurn()
    local etype = randomItemEType(turn)
    local x,y = base.getPlayer(rgbTeam)
    local ent = etype(x,y)
    ent.rgb = itemRGBSelection()
    ent.rgbTeam = rgbTeam
end



return itemPool

