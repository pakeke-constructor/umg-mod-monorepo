

# Refactor document

`state` mod:
gameState, state, pauseState
`getGameTime()` method



`objects` mod:
color, set, array, heap, partition, enum, class




`rendering` mod:
animations
draw
camera
drawStats
`isOnScreen`, `entIsOnScreen`




`input` mod:
Input object



`control` mod:
- Handles control of players, AND control of non-player entities.
controllable component
control component
lookX, lookY components
moveX, moveY components



`juice` mod: (previously called drawfx mod)
entity_shadows
particles
nametags
popups
text
title
shockwave


`soundfx` mod:
sound
- allow for proximity sounds, mixing, special effects api, etc
- have a `Sound` object, that represents the playing of a sound:::
    - can either play 1 sound,
    - or a random sound from a list of other Sound objects.  (nested)



`mortality` mod:
health, maxHealth
handles `onDeath`, `onDamage` callbacks
handles damage modifiers.



`physics` mod






TODO:

Where should `onClick` component go?
Where should mouse_hover (`isHovered` func) go?
(both these things need `input` and `rendering` mod)

SOLUTION: keep it in the `base` mod for now.



Where does `gravity` go? (gravity mod?)



Where does `delay`, `nextTick`, and `runEvery` go? 
(scheduling mod?)



Do we get rid of `base.defineExports`?
(Probably, yes.)



Do we need `components.lua`?
That's the thing; `components` module is probably going to be very useful
in the future; (i.e. worldediting.)
but for now, it's not really needed.
I say, best to wait. YAGNI.



Where should `initializers` go?
A: We should delete `initializers`, and replace it with 
the `@entityInit` stuff.






















Currently, camera-following is implemented in `control`.
How about we remove this, and abstract it to the `zoom` mod.
Then, we rename the `zoom` mod to be `follow`.
This way, `control` wouldn't need to inherit `rendering`.
FUTURE-OLI: ^^^ woops, it still needs to inherit `rendering` because
it needs a translation from screen-coords to world-coords.
(DONE)



Where should `operators` go? Should we even keep this?
A: no, we shouldnt keep operators
Or, we could put operators in the base UMG api?
A2: Create `reducers` mod.
(DONE)

