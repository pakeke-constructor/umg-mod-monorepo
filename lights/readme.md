
# lights mod


### usage:
```lua

graphics.setBaseLighting(0.5,0.5,0.5) 
-- Sets global light level to this amount

graphics.setBaseLighting({0.5,0.5,0.5}) 
-- (works with tables too.)


```


### Defining lights:
Every entity that has a `light`, `x` and `y` component emits light.
```lua

ent.light = {
    color = {1,0,0}; -- the light is red colored.
    radius = 40 -- 40 pixels
}


```
