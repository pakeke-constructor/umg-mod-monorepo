

local DBG_COLS = {
    a = {0.5,0,0},
    b = {0,0,0.5}
}



return umg.extend("abstract_melee", {
    image = "huhu1",
    bobbing = {},

    attackSpeed = 1,
    attackDamage = 8,

    maxHealth = 100,

    abilities = {
        {
            type = "onAllyDeath", 
            filter = function(ent, allyEnt)
                return ent == allyEnt
            end,
            apply = function()
                print("hi")
            end
        }
    },

    init = function(ent, x, y)
        base.initializers.initVxVy(ent,x,y)

        ent.health = 50

        local targC, selfC
        if math.random() > 0.5 then
            targC = "a"
            selfC = "b"
        else
            targC = "b"
            selfC = "a"
        end

        ent.color = DBG_COLS[selfC]

        ent.category = selfC
        ent.rgbTeam = selfC
        ent.attackBehaviourTargetCategory = targC
        ent.moveBehaviourTargetCategory = targC
    end
})

