

# AI final planning:

IDEA:
How about we have INDIVIDUAL components that determine the AI state.

For example:


```lua

ent.ai = AI({
    ...
}) -- an object holding a bunch of useful functions


ent.eyes = {
    fov = 100,
    distance = 400
    -- ... provides vision to the entity.
    -- ent will only react to entities it can see.
}


ent.ears = {
    distance = 600
    -- provides hearing to the entity.
    -- ent will only react to entities it can see.
}


ent.omniscient = true -- ent can sense everything






ent.componentSense = {
    {
        -- ent is scared of all entities with the `fire` component
        -- within a 50 unit radius
        emotion = "fear",
        strength = 10, -- how "strong" the emotion is (units / sec)
        component = "fire",
        distance = 50
        -- NOTE: ent will only be scared of the fire if it can SENSE it!
        -- ie. if it has eyes or ears

        -- strength can also be a function:
        strength = function(ent, evokerEnt)
            return 10 -- returns the "strength" of the emotion
        end
    }, 

    {
        ... 
    }
}


ent.eventSense = {
    {
        emotion = "fear",
        strength = 10,
        event = "explosion", -- ent is scared of explosions

        -- strength can also be a function:
        strength = function(explosionSize) 
            -- this func takes the args passed to the event
            return return explosionSize / 5
        end
    }
}




--[[
    TODO:
    We need more ways for explicit player interaction.
    
    Like, player shoots enemy -> enemy gets angry AT PLAYER.
    Or,
    player looks enemy in eyes -> enemy gets scared OF PLAYER.
    Do some thinking.
]]
-- perhaps a controllableSense component?
ent.controllableSense = {
    -- explicitly detects controllable entities
    ... -- TODO ???
}



```


