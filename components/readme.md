
# components mod
Provides some useful functions for manipulating components.


```lua
-- projects a component onto another component.

-- For example:
components.project("image", "drawable", true)
--[[
This is basically saying:
when an entity gets an `image` component:
    set `ent.drawable = true`
]] 
    

-- We can also do groups:
local g = umg.group("foo", "bar", 42)
components.project(g, "foobar")
--[[
    any entity with `foo` and `bar` components
    automatically get `ent.foobar = 42`
]]

```

