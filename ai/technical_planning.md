

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
        --emotion(s) this event evokes:
        surprise = 1,
        fear = 0.4,
        curiosity = 0.4,
        trust = -0.3 -- negative = decrease trust
    },

    sense = {
        -- how it's sensed
        sound = 1,
        sight = 1,
    }

    class = "impact" -- The "class" of the event.
    -- Some entities may be resistant/ignore certain classes of events.
    -- For example, fire imps might be resistant to events of "fire" class.
})




EMOTION_TYPES = {
    "surprise", -- short-term fear/suprise, i.e. explosion, shotgun blast
    "sadness",
    "trust",
    "joy",
    "anger",
    "curiosity"
    "fear",
    "desire"
}


local SENSE_TYPES = {
    "sight",
    "sound",
    "touch",
    "smell",
}


```






## Components, some ideas:
```lua

ent.hearing = {
    ...
}


ent.vision = {
    distance = X,
    ...
}


```


