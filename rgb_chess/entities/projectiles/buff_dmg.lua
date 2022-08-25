
--[[

This entity is spawned when we want to buff an entity's damage.


]]

local constants = require("shared.constants")

return {

    "x", "y",
    "vx", "vy",
    "particles",

    speed = constants.PROJECTILE_SPEED,
    image = "nothing",

    color = {0.2,0.3,0.9},

    moveBehaviour = {
        type = "follow"
    },

    proximity = {
        -- will emit a buff when it gets within proximity of target.
        enter = function(ent, target_ent)
            if target_ent == ent.proximityTargetEntity then
                if ent.buff_depth < constants.MAX_BUFF_DEPTH then
                    call("buff", target_ent, ent.buff_amount, 0, ent.source_buff_ent, ent.buff_depth + 1)
                    ent:delete()
                end
            end
        end
    },


    init = function(ent, target_ent, buff_amount, source_ent, depth)
        ent.target_buff_ent = target_ent
        ent.buff_amount = buff_amount
        ent.source_buff_ent = source_ent
        ent.buff_depth = depth or 1

        ent.moveBehaviourTargetEntity = target_ent
        ent.proximityTargetEntity = target_ent

        if exists(source_ent) then
            ent.x = source_ent.x
            ent.y = source_ent.y
        else -- else, we set to position of the player.
            local player = base.getPlayer(target_ent.category)
            -- This ^^^ is very crappy!!! 
            ent.x = player.x
            ent.y = player.y
        end

        ent.particles = {
            type = "dust",
            rate = 100
        }
    end
}

