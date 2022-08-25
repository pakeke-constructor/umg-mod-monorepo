

# TODO:


For the base mod, we have `base.animate(...)`.

But this isn't the best....
We need a way to animate *entities* temporarily.
A good way to do this would be to manually set values for the `.image` 
component over a certain time period.
This is WAYYY cleaner than hiding the entity, and animating on top of it.

We just need to ensure that `moveAnimation` or `animation` component doesn't
override our stuff.

How about::
`base.animateEntity(ent, frames)`


