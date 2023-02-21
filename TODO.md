



# PLANNING:

Issue: 

Input blocking.
We need a way to block input well.

Simply calling `input.lock()` isn't good enough,
since that relies on the order of the update event loop.




IDEA:

Create custom input listeners:

```lua

input.lockKeyboard()

input.lockMouseButtons()

input.lockMouseWheel()

```



## MACRO PLANNING:

keypress!
    -> picked up by input system, and buffered

SlabUpdate -->
    if lock is neccessary,
    `input.lockKeyboard()`

`input.update(dt)`




## PIPELINE PLANNING:
keypress!

- Search through Actions; if any actions apply, lock that keypress.
- Push keypress event to the "isOn" array.









# Last solution:

```lua


local listener = input.Listener({
    priority = 10 -- the priority of the listener.
    -- Higher priority --> called first.
})


function listener:keypressed(key, scancode, isrepeat)
    ...
end
function listener:textinput(txt)
    ...
end
function listener:mousepressed(x, y, button, istouch, presses)
    ...
end
function listener:update(dt)
    ...
end





local slabListener = input.Listener({priority = 20})

function slabListener:update(dt)
    Slab.Update(dt)
    Slab.SetScale(base.getUIScale() * SLAB_SCALE_RATIO)
    Slab.DisableDocks(docks)

    umg.call("slabUpdate", self)

    if not Slab.IsVoidHovered() then
        self:lockMouseButtons()
        self:lockMouseWheel()
    end
end

```

We need a way to:
- Lock scancodes per keypress
- Lock mousebuttons per mousepress
And:
- Lock keyboard, mouse, mousewheel per frame


