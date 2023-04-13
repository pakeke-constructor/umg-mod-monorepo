
local IMGS = {
    "ME_Singles_Camping_16x16_Tree_49",
    "ME_Singles_Camping_16x16_Tree_73",
}


return {
    swaying = {magnitude = 0.15},

    oy = -6,

    init = function(ent,x,y)
        ent.x = x
        ent.y = y
        ent.image = table.random(IMGS)
    end
}


