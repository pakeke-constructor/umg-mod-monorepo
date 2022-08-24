
--[[

particle emitters for entities.

If an entity has a `particles` component,
it will emit particles as it moves.

]]

local particles = require("client.particles")


local particleEntities = group("particles", "x", "y")

local DEFAULT_EMIT_RATE = 5


particleEntities:onAdded(function(ent)
    if ent.particles then
        if (type(ent.particles) ~= "table") then
            error("ent.particles needs to be table. Not the case for: " .. ent:type())
        end
        if (not ent.particles.type) or (ent.particles[1] and ent.particles[1].type) then
            error("ent.particles table needs to have a `type` value. Not the case for: " .. ent:type())
        end
    end
end)




local function getPsys(ptable)
    local psys = particles.getParticleSystem(ptable.type)
    local cloned = psys:clone()
    if ptable.spread then
        cloned:setEmissionArea("uniform", ptable.spread.x, ptable.spread.y)
    end
    cloned:setEmissionRate(ptable.rate or DEFAULT_EMIT_RATE)
    return cloned
end



local frameCount = 0


local function updateParticleTable(ent, ptable, dt)
    if not ptable.particleSystem then
        ptable.particleSystem = getPsys(ptable)
    end

    if ent:isRegular("particles") and ent.shouldEmitParticles then
        local emitting = ent:shouldEmitParticles()
        local psys = ptable.particleSystem
        if emitting and psys:isStopped() then
            psys:start()
        elseif (not emitting) and (not psys:isStopped()) then
            psys:stop()
        end
    end

    if (ptable.last_update or 0) < frameCount then
        -- this ensures that particle systems aren't updated twice if they are
        -- shared between entities.
        ptable.particleSystem:update(dt)
        ptable.last_update = frameCount
    end
end


on("update", function(dt)
    frameCount = frameCount + 1
    for _, ent in ipairs(particleEntities)do
        local ent_particles = ent.particles
        if ent_particles.type then
            -- then its just one emitter
            updateParticleTable(ent, ent_particles, dt)
        else
            -- then we have an array of emitters!
            for i=1, #ent_particles do
                updateParticleTable(ent, ent_particles[i], dt)
            end
        end
    end
end)



local function drawParticleTable(ent, ptable)
    local isShared = ent:isShared("particles")
    if ptable.particleSystem then
        local ox, oy = 0,0
        if ptable.offset then
            ox = ptable.offset.x or ox
            oy = ptable.offset.y or oy
        end

        if isShared then
            if ent.shouldEmitParticles and (not ent:shouldEmitParticles()) then
                return
            end
            graphics.draw(ptable.particleSystem, ent.x + ox, ent.y + oy)
        else
            ptable.particleSystem:setPosition(ent.x, ent.y)
            graphics.draw(ptable.particleSystem, ox, oy)
        end
    end
end


on("drawEntity", function(ent)
    local ent_particles = ent.particles
    if ent.particles then
        if ent_particles.type then
            -- then its just one emitter
            drawParticleTable(ent, ent.particles)
        else
            -- then we have an array of emitters!
            for i=1, #ent_particles do
                drawParticleTable(ent, ent_particles[i])
            end
        end
    end
end)


