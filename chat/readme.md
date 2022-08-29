

# chat mod

Press `enter` to open chat.


### Commands:
You can also enter commands.
Enter commands by starting with a `/`.

Example:
`/startGame 1 2 3 4`

```lua
-- server code:

chat.handleCommand("startGame", function(sender, ...)
    print("command from ", sender)
    print("with content: " ,...)
end)

--[[
/startGame 1 2 3 4

OUTPUT:


message from player1
1 2 3 4

]]



