


MODDING OVERVIEW TODO:  (feedback from Turna)
- Explain base mods a little bit.
- In the Entity and Group section, link to bigger explanations.
- Have a link at the top to the wiki.



# Full modding overview.
This overview is meant to be as concise as possible. 
I'm not going to waste your time.     
You must be a programmer with some experience in lua to understand this.   
Also, experience in [love2d](https://love2d.org) helps.

# Table of Contents:
- Basics:
    - [Folder structure](#mod-folder-structure)
- ECS Architecture:
    - [Entities](#entities)
    - [Groups](#groups)
    - [Callbacks](#callbacks)
    - [Client-server communication](#client-server-communication)
- Cheatsheet:
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
        abc.lua -- nested directories work fine. `abc.lua` is loaded.

-- all entities for this mod are defined here.
-- entities are loaded on both client and server.
entities/  
    ball.lua -- ball entity definition file
    player.lua
    enemy.lua

config.toml  -- mod config
```
**NOTE: All Files and folders starting with `_` are ignored.**

----------------------------------------------------------

# ECS Architecture:
This project uses something that resembles an Entity Component System.       
 (Pretty much everything in the world is just an entity.)

## Entities:

An entity is just a glorified lua table, pretty much.<br>
They contain "components", which are just key-values in the table.

What a player entity might look like:
```lua
{
    x = 10, y = 10,
    vx = 0, vy = 0,
    controller = "bob_78",
    image = "player_image",
}
```

Before we create an entity though, we must define it's type!<br>
(Think of this like a "class" in OOP)<br>
To define an entity type, return a table from a file inside of `entities/`.<br>
The ECS will automatically load the entity-type, and put a constructor inside of the global `entities` table.
(Note that in lua, tables are both an array, AND a hashtable.)
```lua
-- entities/my_entity.lua

return {
    "x", "y",  -- these are "regular" components  (the array part)
    "vx", "vy", 
    
    image = "banana", -- these are "shared" components    (the hashtable part)
    color = {1.0, 1.0, 0} -- (think like Java static member)
}
```
The components will determine the behaviour/properties of the entity.<br> 
For example, under the base mod, entities with "x", "y" and "image" components will get drawn to the screen. <br>
(To learn more about how this is accomplished, take a look at the `group` function)

To create an entity instance, use the `entities` table:   
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
    id = 15 -- all entities are assigned an id internally. 
            -- IF YOU MODIFY THIS, STUFF WILL EXPLODE!!! YOU HAVE BEEN WARNED
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

There are a few more entity methods too:
```lua

ent:delete() -- deletes an entity.
-- (This can only be used serverside!)
-- Deleting an entity will automatically delete it for all clients next tick.

ent:type() -- example_mod:my_entity
-- returns the type of the entity.


ent:hasComponent("x")
-- returns true if entity has component `x`, false otherwise

ent:isRegular("compName")
-- returns true if "compName" is a regular component in ent, false otherwise

ent:isShared("compName2") 
-- returns true if compName2 is a shared component in ent, false otherwise


```

## Groups:
"Groups" are what contains entities.
To get a group, we can use the `group` function:

```lua

local drawGroup = group("x", "y", "image")
-- This group automatically takes entities with `x`, `y`, and `image` components.
-- It doesn't matter if the components are shared or regular, as long as the entity has all of them.


drawGroup:onAdded(function(ent)
    ... -- callback for when `ent` is added to drawGroup
end)

drawGroup:onRemoved(function(ent)
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
```lua
load() -- called when the mods and entities are done loading
update ( dt )   -- called every frame (like love.update)
draw  () -- CLIENTSIDE: when stuff should get drawn (like love.draw)
keypressed ( key, scancode, isrepeat )  -- CLIENTSIDE: when a key is pressed (like love.keypressed)
mousepressed (x, y, button, istouch, presses) -- CLIENTSIDE: when mouse is clicked (like love.mousepressed)

tick  ( dt ) -- called every game tick
playerJoin (username) -- called when `username` joins the server
playerLeave (username) -- called when `username` leaves the server
```
Here some other callbacks that are defined by the base mod:
```lua
drawIndex ( i ) -- stuff at Z index `i` should get drawn
drawEntity ( ent ) -- an entity is getting drawn
```


## Client-Server communication

In UMG, there isn't automatic syncing; lots has to be done by mods.

**What IS synced:**
- creation of entities, (and their component values directly upon creation)
- deletion of entities
- joining / leaving of players

**What ISN'T synced:**
- entity component values
- local events (`call` and `on` from above. Client and server have separate buses.)

It's important to note, though, that a lot of syncing is done by base mods.
For example, the `inventory` mod automatically syncs entity inventories.<br>
Likewise, the `base` mod will automatically sync entity positions, entity velocities, entity health, and entity physics bodies.


Client-server communication also uses callbacks:

Server side:
```lua
-- broadcasts `message1` to all clients.
-- you can send any lua data you want, even tables!
server.broadcast("message1",   1, 2, 3, "blah data")


-- Same as broadcast, but it only sends to the client called `playerUsername`.
server.unicast(playerUsername, "message1",   1.0545, 2.9, -5, "random data :)")


-- listens to `moveTo` messages sent by clients
server.on("moveTo", {
    arguments = {checkString}, -- add typecheckers here.
    handler = function(sender_username, msg, ...) 
        print("message from", sender_username)
        print("data:", msg, ...)
    end
})

```

Client side:
```lua
-- send a message to the server.  
-- (same as server.broadcast, but clientside)
client.send("moveTo", x, y) 


-- listens to `message1` from the server
client.on("message1", function(x, y, z, blah)
    print("received message1 from server:  ", x, y, z, blah)
end)

```

Any data can be sent across the network, except for functions and userdata.
If a table is sent across, all nested tables will be serialized and sent across.
If an entity is sent across, it will be efficiently serialized by id.
Sending tables across is the most expensive. Try to only send numbers, strings, and entities across the network for best performance.

If you need to send a metatable across, take a look at the `register` function.
(Remember; functions can't be serialized!)

## Cheatsheet:
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
keyboard  -- ( love.keyboard module )
mouse -- ( love.mouse module )

audio -- (love.audio module)
    -- extra functions:
    audio.getMasterVolume()
    audio.getSFXVolume()
    audio.getMusicVolume()

assets  -- ( holds image and sound assets )
    assets.images  -- ( where quads are loaded )
        assets.images["modname:asset_name"] = love2d_quad, -- OR:
        assets.images["asset_name"] = love2d_quad
    assets.sounds  -- ( where sounds are loaded )
        assets.sounds["modname:sound_name"] = love2d_source,  -- OR:
        assets.sounds["sound_name"] = love2d_source

physics -- (love.physics module)
timer -- (love.timer module)


local mygroup = group("comp1", "comp2", ...)  -- gets an entity group.
-- group methods:
mygroup:onAdded(function(ent) print("ent has been spawned!") end)
mygroup:onRemoved(function(ent) print("ent deleted :(") end)
mygroup:has(ent) -- true/false, whether the group contains `ent`



exists(ent) -- returns `true` if `ent` still exists as an entity, false otherwise

extend("parent_ent", ent_def) 
-- deepcopies all data from entity `parent_ent` into table `ent_def`.
-- useful for doing OOP-like inheritance in entity definitions.


-- Local event dispatch
-- (these exist on both client-side and server-side, but act independently of
-- one another.  For example, the "draw" event is only available client-side)
on(msg, func) -- listens to a local event
call(msg, ...) -- broadcasts a local event



register(name, alias) -- registers a resource for serialization

local data = serialize(obj) -- NOTE: If obj involves an entity, the entity id is set to nil.
local obj, err = deserialize(data) -- deserializes data.

save(name, data) -- saves data to string `name`, (relative to world)
load(name) -- loads data from string `name` (relative to world)

expose("var", value) -- exports `var` to the global mod namespace.
-- Now, all other mods can access `value`.

client  -- Client side functions
    client.send(event_name, ...) -- sends a message to server
    client.on(event_name, func) -- listens to a message from server

    client.atlas -- access to global texture atlas
    -- Images are automatically put in the texture atlas,
    -- and are auto-batched.
    client.atlas:draw(quad, x,y, r, sx,sy, ox,oy) -- draws quad.
    
    client.getUsername() -- gets client username


server
    server.broadcast(event_name, ...) -- broadcasts an event to clients
    server.unicast(username, event_name, ...) -- unicasts to one client
    server.lazyBroadcast(event_name, ...) -- lazy broadcast: efficient, but not guaranteed arrival
    server.lazyUnicast(username, event_name, ...) -- lazy unicast: efficient, but not guaranteed arrival
```

Most lua functions can be used as well, such as `setmetatable`, `rawget`, `pairs`, `require`, etc etc.    
`os`, `io`, `ffi` and `debug` modules have been disabled.

