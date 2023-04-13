

local IMGS = {
    "ME_Singles_City_Props_16x16_Shrub_1",
    "ME_Singles_City_Props_16x16_Shrub_2",
    "ME_Singles_City_Props_16x16_Shrub_5",
    "ME_Singles_City_Props_16x16_Shrub_6",
}


return {
    swaying = {magnitude = 0.04},

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        ent.image = table.random(IMGS)
    end
}

