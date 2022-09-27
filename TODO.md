


# DAY PLAN:


ABSTRACTING PLAYER INPUT:
IDEA:
`base.input` module.

```lua

-- lock player input  (for example, when using chat mod)
base.input.lock()
-- unlock player input
base.input.unlock()

base.input.isLocked() -- returns true/false



base.input.setControls({
    UP = "w",
    LEFT = "a",
    DOWN = "s",
    RIGHT = "d",

    BUTTON_SPACE = "space",

    BUTTON_LEFT = "q",
    BUTTON_RIGHT = "e",

    BUTTON_1 = "r",
    BUTTON_2 = "f",
    BUTTON_3 = "c",
    BUTTON_4 = "x"
})


base.input.isDown(base.input.UP) -- true/false

on("inputPressed", function(inputEnum, isrepeat)
    if inputEnum == base.input.BUTTON_LEFT then
        ...
    elseif inputEnum == base.input.BUTTON_RIGHT then
        ...
    end
end)


on("inputReleased", function(inputEnum, isrepeat)
if inputEnum == base.input.BUTTON_LEFT then
        ...
    elseif inputEnum == base.input.BUTTON_RIGHT then
        ...
    end
end)


```


