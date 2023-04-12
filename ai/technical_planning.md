

## PLANNING:

Don't be afraid to make assumptions about the game structure!
Or else this mod will be too hard to use.




```lua

--[[
    ai agents will react to `explosion` events on serverSide,
    and this will be dispatched to their brain.
    (Assuming that they can sense the explosion.)
]]
ai.listenToEvent("explosion", {
    emotions = {
        --emotion(s) this event evokes
        fear = 1,
        curiosity = 0.15   
    },

    sense = {"sound", "sight"}-- how it's sensed

    class = "impact" -- The "class" of the event.
    -- Some entities may be resistant/ignore certain classes of events.
    -- For example, fire imps might be resistant to events of "fire" class.
})




```






## Components, some ideas:
```lua

ent.sensor = {
    ...
}


ent.vision = {
    distance = X,
    ...
}


```


