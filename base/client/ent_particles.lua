
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
        if (not ent.particles.type) or (ent.particles[1].type) then
            error("ent.particles table needs to have a `type` value. Not the case for: " .. ent:type())
        end
    end
end)




local function doSetup(ptable)
    local psys = particles.get(ptable.type)
    local cloned = psys:clone()
    if ptable.spread then
        cloned:setEmissionArea(ptable.spread.x, ptable.spread.y)
    end
    cloned:setEmissionRate(ptable.rate or 5)
    ptable._particleSystem = cloned
end



local frameCount = 0


local function updateParticleTable(ptable, dt)
    if not ptable._particleSystem then
        doSetup(ptable)
    end

    if ptable.last_update < frameCount then
        -- this ensures that particle systems aren't updated twice if they are
        -- shared between entities.
        ptable._particleSystem:update(dt)
        ptable.last_update = frameCount
    end
end


on("update", function(dt)
    frameCount = frameCount + 1
    for _, ent in ipairs(particleEntities)do
        local ent_particles = ent.particles
        if ent_particles.type then
            -- then its just one emitter
            updateParticleTable(ent_particles, dt)
        else
            -- then we have an array of emitters!
            for i=1, #ent_particles do
                updateParticleTable(ent_particles[i], dt)
            end
        end
    end
end)



local function drawParticleTable(ent, ptable)
    local img = graphics.atlas.image
    if ptable._particleSystem then
        local ox, oy = 0,0
        if ptable.offset then
            ox = ptable.offset.x or ox
            oy = ptable.offset.y or oy
        end

        if ptable.shared then
            graphics.draw(ptable._particleSystem, ent.x + ox, ent.y + oy)
        else
            -- TODO: we may need to store the _particleSystem inside the entity..
            -- do some more thinking.
            graphics.draw(ptable._particleSystem, ox, oy)
        end
    end
end


on("drawEntity", function(ent)
    local ent_particles = ent.particles
    if ent_particles.type then
        -- then its just one emitter
        drawParticleTable(ent, ent.particles)
    else
        -- then we have an array of emitters!
        for i=1, #ent_particles do
            drawParticleTable(ent, ent_particles[i])
        end
    end
end)


