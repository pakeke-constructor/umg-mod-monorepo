
--[[

Projectile entity

]]


local PROJTYPE = constants.PROJECTILE_TYPES


local function assertSource(source)
    assert(source, "Not given a source")
    assert(source.projectileType and PROJTYPE[source.projectileType], "Invalid projectile type for source: " .. tostring(source))
    local ptyp = source.projectileType
    if ptyp == PROJTYPE.CUSTOM then
        assert(source.projectileOnHit, "not given custom projectileOnHit callback")
    elseif ptyp == PROJTYPE.DAMAGE then
        assert(umg.exists(source), "source needs to be entity")
        assert(source.attackDamage, "not given attackDamage")
    elseif ptyp == PROJTYPE.HEAL then
        assert(umg.exists(source), "source needs to be entity")
        assert(source.healAmount, "?")
    elseif ptyp == PROJTYPE.SHIELD then
        assert(umg.exists(source), "source needs to be entity")
        assert(source.shieldAmount, "?")
    end
end


local function assertOptions(options)
    assertSource(options.projectileSource)
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
            local source = ent.projectileSource -- the entity that shot the bullet
            umg.call("rgbProjectileHit", source, target_ent)
            base.kill(ent)
        end
    },

    init = function(ent, x, y, options)
        ent.x = x
        ent.y = y

        assertOptions(options)

        ent.moveBehaviourTargetEntity = options.targetEntity
        ent.proximityTargetEntity = options.targetEntity

        ent.particles = {
            type = "circle",
            rate = 20
        }
    end
}

