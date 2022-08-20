

return {
    "x","y",
    image = "nothing",

    card = {
        name = "BRUTE X 1", -- card name
        description = "hp 5\ndmg 5",
    
        cost = 10,
        
        unit = {
            amount = 1;
            type = "brute";
            damage = 4,
            health = 4
        },
    },

    init = base.entityHelper.initPosition
}


