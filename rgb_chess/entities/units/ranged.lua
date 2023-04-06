
local constants = require("shared.constants")


local DBG_COLS = {
    a = {0.5,0,0},
    b = {0,0,0.5}
}

return umg.extend("abstract_ranged", {
    image = "red_player_up_1",
    bobbing = {},

    projectileType = constants.PROJECTILE_TYPES.DAMAGE,

    attackSpeed = 1,
    attackDamage = 8,

    maxHealth = 100,

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
        ent.attackBehaviourTargetCategory = targC
        ent.moveBehaviourTargetCategory = targC
    end
})

