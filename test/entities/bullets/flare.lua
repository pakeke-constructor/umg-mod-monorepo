

local SHAPE = love.physics.newCircleShape(1)



if client then
    local psys = juice.particles.newParticleSystem({
        "circ4", "circ3", "circ2", "circ1"
    })
    psys:setParticleLifetime(0.4,0.9)
    psys:setColors(
        1,1,1,1,
        0.6,0.6,0.6,0.5
    )
    psys:setEmissionRate(100) -- TODO: this doesn't FRICKEN work!!!!
    psys:setEmissionArea("uniform", 1, 1, 0)
    juice.particles.define("flare", psys)
end


return {
    moveRotation = true,
    draw = true,

    image = "shotgunshell",

    particles = {
        { type = "flare", offset = {x = 0, y = 0} },
    },

    physics = {
        shape = SHAPE,
        --type = "kinematic"
    },

    light = {
        size = 500,
        color = {1,0.95,0.95}
    }
}

