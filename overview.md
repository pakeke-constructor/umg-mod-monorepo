

# full modding overview.
This overview is meant to be as concise as possible. 
I'm not going to waste your time.

You must be a programmer with some experience in lua to understand this.


## Mod folder structure:
Each mod has a folder structure as follows:
```lua

assets/
    sounds/ -- sounds and images go here.
    images/ -- they are automatically loaded on clientside.

server/
    file1.lua -- these files are automatically loaded
    blah.lua  -- on serverside

client/
    cl_file.lua -- these files are auto-loaded on clientside.
    nested/
        abc.lua -- nested directories work fine. `abc` is loaded.

-- all entities for this mod are defined here.
-- entities are loaded on both client and server.
entities/  
    ball.lua -- ball entity definition file
    player.lua
    enemy.lua

config.toml  -- mod config
```

**NOTE: All Files and folders starting with `_` are ignored.**

## Mod naming / uploading:

The name of the mod is determined by where it lives on github.

For example, `github.com/John/appleMod` will have a mod name of
`John.appleMod`.
To upload a mod, simply put it on github.


----------------------------------------------------------

# ECS Architecture:
This project uses something that resembles an Entity Component System. 
 (Pretty much everything in the world is just an entity.)

## Entities:

To define an entity type, return a table from a file inside of `entities/`:
```lua
-- filename:
-- my_entity.lua

return {
    "x", "y",  -- these are "regular" components
    "vx", "vy",
    
    image = "banana", -- these are "shared" components
    color = {1.0, 1.0, 0} -- (think like Java static member)
}
```
We can create an entity using the `entities` table.

Assuming the filename was `entities/my_entity.lua`:
```lua
local ent = entities.my_entity()
ent.x = 69
ent.y = 4001
ent.vx = 0
ent.vy = 0

print(ent)
--[[ 
OUTPUT:

[example_mod:my_entity] {
    x = 69,
    y = 4001,
    vx = 0,
    vy = 0
}
]]
```

The `image` and `color` components are not printed out, because these components are "shared" between all instances of `my_entity`.

Next tick, `ent` will get sent over to all clients automatically. 
(Only the "regular" components are sent over the network.)

To delete an entity, use `ent:delete()`.
This can only be used on server-side. Deleting an entity will automatically delete
it for all clients next tick.

## Groups:
"Groups" are what contains entities.
To get a group, we can use the `group` function:

```lua

local drawGroup = group("x", "y", "image")
-- This group automatically takes entities with `x`, `y`, and `image` components.
-- It doesn't matter if the components are shared or regular, as long as the entity has all of them.


drawGroup:on_added(function(ent)
    ... -- callback for when `ent` is added to drawGroup
end)

drawGroup:on_removed(function(ent)
    ... -- callback for  when `ent` is removed from drawGroup
    -- (This will only happen if `ent` is deleted.)
end)


local function draw()
    -- iteration is the same as a regular lua array.
    for _, ent in ipairs(drawGroup) do
        ...
    end
end


drawGroup:len() -- gets length of a group

drawGroup:has(ent) -- returns true if `ent` is in drawGroup, false otherwise.

```

## Callbacks:
Callbacks are used to broadcast events and hook onto them. It's just the Observer pattern.

Callbacks can be used on clientside AND serverside, but are independent of one another.   
I.e. if I do `call("event", ...)` on clientside, this event will ONLY be received on clientside.   
(There is a seperate event bus for client-server communication; but don't worry about that for now)

Example:
```lua
on("hello", function(...)
    -- creates a function that listens to `hello` events
    print("Hello one: ", ...)
end)


on("hello", function(...)
    -- creates another function that listens to `hello` events
    print("Hello two: ", ...)
end)


-- emits a `hello` event.
call("hello", 1, 2, 3)
--[[ 
OUTPUT:

Hello one: 1 2 3
Hello two: 1 2 3
]]
```



