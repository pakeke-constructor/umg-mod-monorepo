

# wireworld planning:

Components:
```lua

ent.conductive = true -- this entity can conduct pulse



ent.pulse = X -- how much pulse this ent carries this tick
-- Pulse can be negative!


-- Conductive properties:
ent.resistance = 1 -- how effective this entity is at conducting
-- (default = 1)
-- negative resistance: flips the "sign" of the pulse
-- resistance < 1: magnifies the pulse
-- resistance > 1: decreases the pulse

ent.reactance = 1 
--[[
    TODO:
    What should reactance do?
    We want circuits to be easy to make.
    - AND, OR gates should be easy to make
    Try make it so reactance relates to multiple inputs, perhaps?
]]
--[[
    IDEA:
    when reactance is positive, it receives positive
]]



--[[
    both reactance and resistance should be properties,
    defined by the properties mod.
]]

```

## Emergence:
We want any entity to be able to conduct pulse.

For example, the player.


## Alternative electrical components:

Make it SUPER easy for other entities to interface with electricity.

Examples:
- Pusher machine:
    - when negative pulse, pulls entities towards it
    - when positive pulse, pushes entities away from it
    - strength of push is determined by strength of pulse
- Detector:
    - When an entity enters its radius, emits a positive pulse
    - When an entity leaves, emits a negative pulse
- Crafter: When receiving a pulse, executes a craft
- Furnaces: emit a small pulse when they finish smelting.
- Piston-Wall: becomes solid when charged, down when un-charged




