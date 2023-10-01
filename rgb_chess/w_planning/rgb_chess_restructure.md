

# Rgb-chess restructure:
Planning for the restructure of rgb-chess.
We ideally want to extrapolate a bunch of behaviour to base mods.




## Brainstorming:

- Extrapolate `abilities` to a base mod: The `upgrades` mod.
    The upgrades mod should handle simple upgrades, 
    such as +DMG and stuff, but should *also* handle more 
    complex upgrades like rgb-chess abilities.

    Ideally, we want the `upgrades` mod to be able
    to handle complex upgrades, like the binding of isaac.

    Do some thinking ^^^^.
    IF YOU IMPLEMENT THIS CORRECTLY, THIS COULD BE A COMPLETE BREAKTHROUGH FOR THE ECOSYSTEM.

-------------

Removed ranged entities; ranged ents are supported by `projectiles` mod.
We need an readily-available way of representing melee attacks.

- We could extrapolate melee attacks to the `action` mod:
    The `action` mod defines a few properties:
        - strength property
        






