

# The action problem:
Im writing this here because its a really important problem
that I'd be happy with spending many hours on "solving".

----------

### OPTION-1:
Currently, with `triggerEffect`s, the action lies INSIDE the `triggerEffect` component.

This is "fine"... but I feel like we can do better.

What if we want the following upgrade:
```
Upon taking damage: Trigger all other effects this entity has
    - Requires meta/reflective behaviour
    - Requires a well-defined trigger format
```

Suddenly, we gotta iterate over `triggerEffect` ents, and apply their action awkwardly.
This is a bit awkward/dirty, because the `triggerEffect` is for TRIGGERS, not for ACTIONS.

What can we do?

### OPTION-2:
A solution is to split `triggerEffect` into 2 parts:
- trigger: What causes it
- action: What actually happens

An `action` is just a regular component on an entity, that signals
that the entity has an "action" that it can carry out.

This way, the `action` component can also be used OUTSIDE of `triggerEffect`s.
Actions would represent a much broader class of stuff.


------------

The other reason that I dislike OPTION-1 is because of a slight violation of UMG's vision.

With OPTION-1, all of the behaviour of the action is baked into a function inside the `triggerEffect`.

With OPTION-2, however, we can have a bunch of components related to the action that define what the action is.

For example:
```lua
-- emits projectiles in a burst around the applier entity
ent.projectileBurstAction = {
    projectileType = "bullet",
    count = 8 -- shoots 8 projectiles around the entity
}
```

