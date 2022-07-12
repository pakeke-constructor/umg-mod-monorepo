

# full modding overview.
This overview is meant to be as concise as possible. 
I'm not going to waste your time.     
You must be a programmer with some experience in lua to understand this.   
Also, experience in [love2d](https://love2d.org) helps.

# Table of Contents:
- Basics:
    - [Folder structure](#mod-folder-structure)
    - [Mod names / uploading](#mod-naming-and-uploading)
- ECS Architecture:
    - [Entities](#entities)
    - [Groups](#groups)
    - [Callbacks](#callbacks)
    - [Client-server communication](#client-server-communication)
    - [General API reference](#general-api-reference)


## Mod folder structure:
Each mod has a folder structure as follows:
```lua

assets/
    sounds/ -- sounds and images go here.
    images/ -- they are automatically loaded on clientside.
-- images are automatically put in the texture atlas (graphics.atlas) for auto-batching.

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

## Mod naming and uploading:
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
The components will determine the behaviour/properties of the entity.    
For example, under the `base` mod, entities with `x`,`y` and `image` will get drawn to the screen. 

To create an instance, use the `entities` table:   
(Assume the filename was `entities/my_entity.lua`)
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
    id = 15 -- all entities are assigned an id. 
            -- This is the only "special" component
    x = 69,
    y = 4001,
    vx = 0,
    vy = 0
}
]]
```

The `image` and `color` components are not printed out,     
because these components are "shared" between all instances of `my_entity`.

Next tick, `ent` will get sent over to all clients automatically.    
(Only the "regular" components are sent over the network.)

To delete an entity, use `ent:delete()`.     
This can only be used on server-side.     
 Deleting an entity will automatically delete it for all clients next tick.


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
    for i, ent in ipairs(drawGroup) do
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


-- emits a `hello` event:
call("hello", 1, 2, 3)
--[[ 
OUTPUT:

Hello one: 1 2 3
Hello two: 1 2 3
]]
```

Some callback events are emitted automatically by the engine:
```
update ( dt )   -- called every frame (like love.update)
draw  () -- CLIENTSIDE: when stuff should get drawn (like love.draw)
keypressed ( key, scancode, isrepeat )  -- CLIENTSIDE: when a key is pressed (like love.keypressed)
mousepressed (x, y, button, istouch, presses) -- CLIENTSIDE: when mouse is clicked (like love.mousepressed)

tick  ( dt ) -- called every game tick
join (username) -- called when `username` joins the server
leave (username) -- called when `username` leaves the server
```
Here some other callbacks that are defined by the base mod:
```
drawIndex ( i ) -- stuff at Z index `i` should get drawn
drawEntity ( ent ) -- an entity is getting drawn
```


## Client-Server communication
Client-server communication also uses callbacks:

Server side:
```lua
-- broadcasts `message1` to all clients.
server.broadcast("message1",   1, 2, 3, "blah data")


-- Same as broadcast, but it only sends to the client called `playerUsername`.
server.unicast("message1", playerUsername,   1, 2, 3, "blah data")


-- listens to `moveTo` messages sent by clients
server.on("moveTo", function(sender_username, ...)
    print("message from", sender_username)
    print("data:", ...)
end)

```

Client side:
```lua
-- send a message to the server.
client.send("moveTo", x, y) 


-- listens to `message1` from the server
client.on("message1", function(x, y, z, blah)

end)

```

Functions cannot be sent across the network.
If a table is sent across, all nested tables will be serialized and sent across.
If an entity is sent across, it will be serialized by id.   
Sending tables across is somewhat expensive. Try to only send numbers, strings, and entities across the network for best performance.

If you need to send a metatable across, take a look at the `register` function.

## General API reference
These are all the functions/modules that can be used whilst modding:  
```lua
math  -- (lua math module)
    -- extra functions:
    math.vec2(x,y) -- vector2 class
    math.vec3(x,y) -- vector3 class
    math.clamp(x, lower, upper)
    math.round(x)
    math.lerp(...)
    math.distance(x, y, [z]) -- z is optional argument. Gets euclidean distance

graphics -- (love.graphics module)
    -- extra stuff:
    graphics.atlas -- access to global texture atlas
    -- Images are automatically put in the texture atlas,
    -- and are auto-batched.
        graphics.atlas:draw(quad, x,y, r, sx,sy, ox,oy) -- draws quad.

keyboard  -- ( love.keyboard module )
mouse -- ( love.mouse module )

audio -- (love.audio module)
    -- extra functions:
    audio.getMasterVolume()
    audio.getSFXVolume()
    audio.getMusicVolume()

assets  -- ( holds image and sound assets )
    assets.images   ( where quads are loaded )
        ["modname:asset_name"] = love2d_quad,  OR
        ["asset_name"] = love2d_quad
    assets.sounds   ( where sounds are loaded )
        ["modname:sound_name"] = love2d_src,  OR
        ["sound_name"] = love2d_src

physics -- (love.physics module)
timer -- (love.timer module)

local g = group("comp1", "comp2", ...)  -- gets an entity group.

exists(ent) -- returns `true` if `ent` still exists as an entity, false otherwise


-- Local event dispatch
on(msg, func) -- listens to an event
call(msg, ...) -- broadcasts an event



register(name, alias) -- registers a resource
local data = serialize(obj) -- NOTE: If obj involves an entity, the id is set to nil.
local obj, err = deserialize(data) -- deserializes data.

save(name, data) -- saves data to `name`, (relative to world)
load(name) -- loads data from `name` (relative to world)

export("var", value) -- exports `var` to the global mod namespace.
-- Now, all other mods can access `value` in their global environment.

client  -- message sending/receiving for client
    client.send(msg, ...) -- sends a message to server
    client.on(msg, func) -- listens to a message from server

server
    server.broadcast(msg, ...) -- broadcasts to clients
    server.unicast(username, msg, ...) -- unicasts to one client
    server.lazyBroadcast(msg, ...) -- lazy broadcast: efficient, but not guaranteed arrival
    server.lazyUnicast(msg, ...) -- lazy unicast: efficient, but not guaranteed arrival

username -- The player's username.  (Available client side ONLY)
```

Most lua functions can be used as well, such as `setmetatable`, `rawget`, `pairs`, `require`, etc etc.    
`os`, `io`, `ffi` and `debug` modules have been disabled.

