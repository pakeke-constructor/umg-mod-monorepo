

# Refactor document

`state` mod:
gameState, state, pauseState


`objects` mod:
color, set, array, heap, partition, enum, class


`input` mod:
Input object



`rendering` mod:
animations
draw
camera
hover (`isHovered` func)
drawStats
`isOnScreen`, `entIsOnScreen`



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
    - or a random sound from a list. (Sound objects can be nested)



`mortality` mod:
health, maxHealth
handles `onDeath`, `onDamage` callbacks



TODO:

Where should `onClick` component go?

where should `lookX`, `lookY` components go?

Where should `initializers` go?
Do we even need this file....?

Where should `operators` go? Should we even keep this?

