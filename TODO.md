



# PLANNING:

Issue: 

Input blocking.
We need a way to block input well.

Simply calling `input.lock()` isn't good enough,
since that relies on the order of the update event loop.




IDEA:
Create custom input listeners:

```lua

input.whenDown({
    input = input.UP,
    priority = 10, -- higher priority = called first
    call = function(scancode, dt)
        if State.getState() == "game" then
            ... -- do something
            input.lockKey(scancode)
        end
    end
})

input.onPress({
    priority = 5,
    call = function(scancode, isrepeat)
        textBuffer = textBuffer .. scancode
    end
})






```

