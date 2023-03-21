

local IMGS = {
    "ME_Singles_Camping_16x16_Mushrooms_1",
    "ME_Singles_Camping_16x16_Mushrooms_2",
    "ME_Singles_Camping_16x16_Mushrooms_3"
}


return {
    bobbing = {magnitude = 0.04},

    init = function(ent, x, y)
        ent.x = x
        ent.y = y
        ent.image = table.pick_random(IMGS)
    end
}

