



# PLANNING:






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






```lua

```

We need a way to:
- Lock scancodes per keypress
- Lock mousebuttons per mousepress
And:
- Lock keyboard, mouse, mousewheel per frame


