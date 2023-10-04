

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

Completely refactor (and rename) the `moveBehaviour` mod.
It's bad, and a bunch of it was replaced with `moveX` and `moveY`.
Currently moveBehaviour is just a bit *too* specialized and complicated.

Some more simple components would be great to have, though:

- A `moveToTarget` component 
    - (causes `moveX` and `moveY` values to be set to target-ent)
    - This would allow for homing bullets.
    - The `control` mod or `move_behaviour` mod should define this

Do some more thinking.


-------------

Ranged entities: <br/>
Currently, bullets are well-supported by the `projectiles` mod.
But we need some extra functionality for it to work in rgb-chess.
We need:
- Bullets that are not physics-based
- Bullets that only collide with a specific entity (i.e targetted)

(You may be tempted to add an API that creates projectiles.
But this is a dumb idea; because projectiles are just regular entities.
Why not just instantiate the entities..?)


----------

We need to extract melee attacks into a base mod somehow.
I can't think of a clean way to do it, though.

The problem is that we are lowkey solving 2 problems in one:

- Problem 1: attack-behaviour of entities:
    - when does an entity attack?
    - who does the entity attack? etc
- Problem 2: Dispatch of melee attack
    - how much damage does entity do?
    - How many targets does the attack have? etc

Problem-2 can perhaps be ignored, if the infrastructure of the solution to problem-1 is good enough.


### IDEA 1:
Extrapolate attack-behaviour stuff to `actions` mod.

The `actions` mod will provide a well-defined way for entities
to invoke single-time actions.
(Kind of like how `moveX` and `moveY` provide movement.)

IMPORTANT NOTE:
`actions` mod is unrelated to attacking.
It just provides an interface for actions to be defined/executed.

We should be able to add attacking in easily, though.

Future thoughts:
We should also make the `actions` mod future-compatible with the `ai` mod.<br/>
In fact, ideally, (if we do decide to implement the actions mod,)
the `ai` mod should extend the `actions` mod, and tag into it.

Do some thinking!!! ^^^^^


