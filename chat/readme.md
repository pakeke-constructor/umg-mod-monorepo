

# chat mod

Press `enter` to open chat.


### Commands:
You can also enter commands.
Enter commands by starting with a `/`.

Example:
`/startGame 1 2 3 4`

```lua
-- server code:

chat.handleCommand("startGame",  {
    handler = function(sender, x, y)
        print("command from: ", sender)
        print("with position: ", x, y)
    end,

    adminLevel = 5, -- minimum level required to execute this command

    arguments = {
        {type = "number", name = "x"},
        {type = "number", name = "y"}
    }
})

--[[
/startGame 1 2

OUTPUT:


message from player1
1 2

]]



