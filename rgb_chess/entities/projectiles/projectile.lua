
--[[

Projectile entity

]]


local PROJTYPE = constants.PROJECTILE_TYPES

local function assertOptions(options)
    local ptyp = options.projectileType
    assert(options.sourceEntity, "needs a source entity")

    if ptyp == PROJTYPE.CUSTOM then
        local src = options.sourceEntity
        assert(src and src.projectileOnHit, "need to give a sourceEntity that has a .projectileOnHit callback")

    elseif ptyp == PROJTYPE.DAMAGE then
        assert(options.attackDamage, "not given attackDamage")
        
    elseif ptyp == PROJTYPE.HEAL then
        assert(options.healAmount, "?")

    elseif ptyp == PROJTYPE.SHIELD then
        assert(options.shieldAmount, "?")
    end

    assert(options.projectileType and PROJTYPE[options.projectileType], "Invalid projectile type for source: " .. tostring(source))
    assert(umg.exists(options.targetEntity), "Not given a targetEntity") 
end




local constants = require("shared.constants")

return {
    speed = constants.PROJECTILE_SPEED,
    image = "bullet",

    moveRotation = {};

    moveBehaviour = {
        type = "follow"
    },

    proximity = {
        targetCategory = "enemy",
        range = 100,

        enter = function(ent, target_ent)
            umg.call("rgbProjectileHit", ent, target_ent)
            base.server.kill(ent)
        end
    },

    init = function(ent, x, y, options)
        ent.x = x
        ent.y = y

        assertOptions(options)
        for k,v in pairs(options)do
            ent[k] = v
        end

        ent.moveBehaviourTargetEntity = options.targetEntity
        ent.proximityTargetEntity = options.targetEntity

        ent.particles = {
            type = "circle",
            rate = 20
        }
    end
}

