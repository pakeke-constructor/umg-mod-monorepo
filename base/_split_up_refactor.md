

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



`drawfx` mod:
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
(both these mods need `input` and `rendering` mod)



Where should `initializers` go?
A: We should delete `initializers`, and replace it with 
the `@entityInit` stuff.


Where should `operators` go? Should we even keep this?
A: no, we shouldnt keep operators

