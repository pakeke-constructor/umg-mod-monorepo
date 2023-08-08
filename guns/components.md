


# gun components


```lua


ent.projectileLauncher = {
    projectileType = "my_projectile", -- projectile entity

    spawnProjectile = function(holderEnt, gunEnt, i)
        -- `i` is the projectile number.
        return entities.my_projectile()
        -- This entity will be given the appropriate velocity, position,
        -- dimension values by the system.
    end,

}


```


### PLANNING:
What do we want for projectileLauncher?

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



