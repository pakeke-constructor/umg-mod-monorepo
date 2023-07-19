

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
hover (`isHovered` func)
drawStats
`isOnScreen`, `entIsOnScreen`




`input` mod:
Input object

`control` mod:
controllable component
Input class




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

where should `lookX`, `lookY` components go?


Where should `initializers` go?
TODO: We should delete `initializers`, and replace it with 
the `@entityInit` stuff.


Where should `operators` go? Should we even keep this?

