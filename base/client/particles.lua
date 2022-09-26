

local particles = {}

local Set = require("shared.set")
local Array = require("shared.array")





local nameToPsys = {
--[[
    [name] = love_particleSystem
]]
}


local availablePSyses = setmetatable(
{     -- Arrays of available particle systems, keyworded by type
--[[
    [name] = array_of_available_psyses
]]
}, 
{__index = function(t,k) t[k] = Array() return t[k] end}
)


local drawingPSyses = setmetatable(
    -- 2d array of particle systems that are being drawn, keyed by draw index.
    {}, {__index = function(t,k) t[k] = Set() return t[k] end}
)


local in_use = Set()


local floor = math.floor

local function get_z_index(y,z)
    return floor((y+z)/2)
end



local function get_emitter(name)
    --[[
        gets emitter of certain type from the queue of that type.
        (also removes from queue)
    ]]
    local availables = availablePSyses[name]
    if #availables > 0 then
        -- there is an available system to use!
        return availables:pop()
    else
        return nil -- else return nil
    end
end



local function drawEmitter(emitter)
    graphics.setColor(emitter.color)
    local psys = emitter.psys
    graphics.draw(psys) -- Under most recent love version, this breaks batching. 
    -- Oh well :/
end



on("drawIndex", function( z_dep )
    for _, emtr in drawingPSyses[z_dep]:iter() do
        drawEmitter(emtr)
    end
end)



local function isFinished(emitter)
    local runtime = emitter.runtime
    local _, lifetime = emitter.psys:getParticleLifetime()
    if runtime > lifetime then
        return true
    end
end

on("update", function(dt)
    for _, emitr in in_use:iter() do
        emitr.psys:update(dt)
        emitr.runtime = emitr.runtime + dt
        if isFinished(emitr) then
            in_use:remove(emitr)
            drawingPSyses[emitr.z_dep]:remove(emitr)
            emitr.runtime = 0

            availablePSyses[emitr.name]:add(emitr)
        end
    end
end)




local function applyDefaults(psys)
    psys:setParticleLifetime(0.4, 0.7)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,6)
    psys:setColors({1,1,1}, {1,1,1,0.7})
    psys:setSpin(-5,5)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
end



local DEFAULT_BUFFER_SIZE = 50

function particles.newParticleSystem(images, buffer_size)
    if #images == 0 then
        error("Attempted to define a particleSystem with no particle images")
    end
    local psys = graphics.newParticleSystem(graphics.atlas.image, buffer_size or DEFAULT_BUFFER_SIZE)
    local buffer = Array()
    local _,pW,pH
    for _,img in ipairs(images) do
        local quad = assets.images[img]
        _,_,pW,pH = quad:getViewport()
        assert(quad, "base.particles.newParticleSystem(): Non existant image: " .. tostring(img))
        buffer:add(quad)
    end

    psys:setQuads(buffer)
    applyDefaults(psys)
    psys:setOffset(pW/2, pH/2)
    
    return psys
end



function particles.define(name, psys)
    if type(name) ~= "string" then
        error("particles.define(name, images) expects a string name as first arg, got: " .. type(name))
    end
    if nameToPsys[name] then
        error("duplicate particle definition: " .. name)
    end
    if type(psys) ~= "userdata" or (not psys:typeOf("ParticleSystem")) then
        error("particles.define takes a love2d particleSystem as second arg, but got: " .. type(psys))
    end
    
    nameToPsys[name] = psys
end



local DEFAULT_COLOR = {1,1,1}
local DEFAULT_PARTICLES = 10 -- default number of particles to emit



function particles.emit(name, x, y, z, num_particles, color)
    num_particles = num_particles or DEFAULT_PARTICLES
    color = color or DEFAULT_COLOR
    z = z or 0
    
    if not nameToPsys[name] then
        error("Unrecognised particle name: "..tostring(name) .. ".\nMake sure to register particles with `base.defineParticles()!`")
    end

    local emitter = get_emitter(name)

    if not emitter then
        -- No available emitters in the pool; create a clone.
        emitter = {
            psys = nameToPsys[name]:clone();
            name = name
        }
    end

    local z_dep = get_z_index(y,z)
    emitter.z_dep = z_dep
    emitter.y = y
    emitter.z = z
    emitter.x = x
    emitter.runtime = 0
    emitter.color = color

    local psys = emitter.psys
    psys:setPosition(emitter.x, emitter.y - emitter.z / 2)
    psys:emit(num_particles)

    in_use:add(emitter)

    drawingPSyses[z_dep]:add(emitter)
end



function particles.getParticleSystem(name)
    return nameToPsys[name]
end



return particles


