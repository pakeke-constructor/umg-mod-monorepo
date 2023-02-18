



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
    update = function(scancode, dt)
        ... -- do something
        return true -- lock
    end
})

input.onAction({
    priority = 5,
    onPress = function(scancode, isrepeat)
        if isTyping then
            textBuffer = textBuffer .. scancode
            return true -- lock
        else
            return false -- no lock
        end
    end,
    onRelease = function(scancode)
    end
})


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





