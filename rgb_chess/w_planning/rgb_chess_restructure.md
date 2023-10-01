

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

    DO SOME THINKING. ^^^^
    This has the potential to be a complete breakthrough for the ecosystem.

-------------

moveBehaviour mod:

Kill (or refactor) the `moveBehaviour` mod.
It's bad, and a bunch of it was replaced with `moveX` and `moveY`.
Currently moveBehaviour is just a bit *too* specialized and complicated.

Some more simple components would be great to have, though:

- A `moveToTarget` component 
    - (causes `moveX` and `moveY` values to be set to target-ent)
    - This would allow for homing bullets.
    - The `control` mod or `move_behaviour` mod should define this


-------------

Ranged entities: <br/>
Currently, bullets are well-supported by the `projectiles` mod.
But we need some extra functionality for it to work in rgb-chess.
We need:
- Bullets that are not physics-based
- Bullets that only collide with a specific entity (i.e targetted)



-----------

- We need to extrapolate melee attacks to base mod.
    The `action` mod defines a few properties:
        - strength property
        






