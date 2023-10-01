


# projectile components


```lua


-- defines a `shooter` item:
ent.shooter = {
    mode = 1, -- use mode
    projectileType = "my_projectile", -- projectile entity type

    -- alternatively, we can define a `spawnProjectile` function:
    spawnProjectile = function(holderEnt, gunEnt, i)
        -- `i` is the projectile number.
        return entities.my_projectile()
        -- This entity will be given the appropriate velocity, position,
        -- dimension values by the system.
    end,

    speed = 20, -- speed of projectiles
    count = 1, -- num fired

    -- 0 = fully accurate
    -- math.pi = bullets may change direction by up to 90 degrees!!!
    inaccuracy = 0,

    -- Spread of projectiles, used if multiple are shot.
    -- angle in radians.
    spread = math.pi/4,

    -- the distance away that the projectiles spawn at
    startDistance = 20,

    --[[
        TODO: Put more stuff here afterwards.
        We want fire-rate, canShoot question/callbacks,
    ]]
    -- TODO: Not yet implemented:
    firerate = 3, -- 3 projectiles per second
    canShoot = function() end,
    -- etc etc.
}


ent.





-- This entity serves as a projectile
ent.projectile = {
    onHit = function(projEnt, targetEnt, contact)
        -- custom logic here
    end,

    size = 10, -- the hitbox size
    damage = 10, -- deals 10 damage on hit, (if the target has health)
    sound = "hit", -- plays this sound on hit

    lifetime = 3, -- projectile lifetime in seconds
}




--[[

TODO: 
gun component that provides a bunch of sensible defaults.
Also plays a default sound, and emits default particles.
Afterwards, provides a bunch of default sounds/particles to choose from.

]]
ent.gun = {
    bulletType
}


```


### PLANNING:

We want:
- multiple projectiles
    - variation / random number of projectiles?
    - min/max number?

- accuracy 
    - min/max spread? 
    - question for getting accuracy? (i.e less accurate when moving)

- projectile directions for multiple projectiles
    - (eg triple shot in b-of-isaac)

- types of projectile entities
I.e. what type of projectile are we shooting?
    - randomized projectile entities?
    - question for getting projectile entity type
^^ The difficulty with this one is that we need 2-way communication.
So... perhaps a `collect` reducer is best for this...? idk.


- projectile velocity
    - question for projectile velocity?
        - do we need the projectile ent for the question...?



