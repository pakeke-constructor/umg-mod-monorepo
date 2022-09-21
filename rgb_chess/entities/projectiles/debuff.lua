

--[[

Abstract entity for buffing.

This creates a cool particle effect that flies over, and increases entity stats.
(used by server/buffapi )


]]



local constants = require("shared.constants")

return {
    "x", "y",
    "vx", "vy",
    "particles",
    "debuffType",
    "color",

    speed = constants.PROJECTILE_SPEED / 2,
    image = "nothing",

    moveBehaviour = {
        type = "follow";
        stopDistance = 0;
    },

    proximity = {
        -- will emit a buff when it gets within proximity of target.
        enter = function(ent, target_ent)
            if server and target_ent == ent.proximityTargetEntity then
                if ent.buff_depth < constants.MAX_BUFF_DEPTH then
                    local debuff_type = ent.debuffType
                    call("debuff", target_ent, debuff_type, ent.buff_amount, ent.source_buff_ent, ent.buff_depth + 1)
                    ent:delete()
                end
            end
        end;
        range = 20
    },

    init = function(ent, target_ent, debuff_type, buff_amount, source_ent, depth)
        assert(
            debuff_type and constants.BUFF_TYPES[debuff_type], 
            "ent.debuffType needs to be defined in the child entity."
        )
        ent.debuffType = debuff_type
        ent.target_buff_ent = target_ent
        ent.buff_amount = buff_amount
        ent.source_buff_ent = source_ent
        ent.buff_depth = depth or 1

        ent.moveBehaviourTargetEntity = target_ent
        ent.proximityTargetEntity = target_ent

        if source_ent then
            ent.x = source_ent.x
            ent.y = source_ent.y
        else -- else, we set to position of the player.
            local player = base.getPlayer(target_ent.rgbTeam)
            ent.x = player.x
            ent.y = player.y
        end

        ent.particles = {
            type = "dust",
            rate = 100
        }
    end
}

