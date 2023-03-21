

local IMGS = {
    "ME_Singles_Villas_16x16_Villa_Yard_Flowers_4",
    "ME_Singles_Villas_16x16_Villa_Yard_Flowers_5",
    "ME_Singles_Villas_16x16_Villa_Yard_Flowers_6",
    "ME_Singles_Villas_16x16_Villa_Yard_Flowers_7",
    "ME_Singles_Villas_16x16_Villa_Yard_Flowers_8",
    "ME_Singles_Villas_16x16_Villa_Yard_Flowers_9"
}


return {
    swaying = {magnitude = 0.05},

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}

