

# dimensions refactor plan:


## refactor position passing:

IDEA: Instead of passing `x,y,z,dimension` into every function manually,
how about we create a `dimensionVector` object of the following shape:
```lua
{
    x: number,
    y: number,
    dimension: string?
    z: number? 
}
```
that way, we can pass positions/dim values around more easily.
AND WHATS BETTER:
Is that if we don't want to allocate an object, we can simply pass in
the entity instead!!! (Amazing.)











# What mods need to change:

- chunking
partition data structure should contain positions,
AND dimension values for entities.

- rendering
we need to create Z-indexers for each dimension.
camera should contain dimension too. 
there should be an API for switching camera between dimensions.

- physics
each dimension needs a physics world


- juice mod
particles, sfx, etc use `dimensionVector`


- light mod
check dimension of light before rendering


