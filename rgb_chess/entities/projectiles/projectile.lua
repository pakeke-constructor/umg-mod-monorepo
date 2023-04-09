
--[[

Projectile entity

Projectiles can be shot by unit entities,
OR by item entities.

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
    
    elseif ptyp == PROJTYPE.BUFF then
        assert(options.buffAmount, "?")
    end

    assert(options.projectileType and PROJTYPE[options.projectileType], "Invalid projectile type: " .. tostring(options.projectileType))
    assert(umg.exists(options.targetEntity), "Not given a targetEntity") 
end




local constants = require("shared.constants")

return {
    speed = constants.PROJECTILE_SPEED,
    image = "bullet",

    moveRotation = {};

    moveBehaviour = {
        type = "follow",
        stopDistance = 0
    },

    rgbProjectile = true,

    proximity = {
        range = 4,
        enter = function(ent, target_ent)
            umg.call("rgbProjectileHit", ent, target_ent)
        end
    },

    init = function(ent, x, y, options)
        --[[
            options = {
                projectileType = constants.PROJECTILE_TYPES.*,
                targetEntity = <target>
                sourceEntity = <source ent>
                ...
            }
        ]]
        base.initializers.initVxVy(ent,x,y)

        assertOptions(options)
        for k,v in pairs(options)do
            ent[k] = v
        end

        ent.moveBehaviourTargetEntity = options.targetEntity
        ent.proximityTargetEntity = options.targetEntity
    end
}

