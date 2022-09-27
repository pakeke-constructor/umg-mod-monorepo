
a = [
     "update", "draw",
     "keypressed", "keyreleased",
     "textedited",
     "focus", "resize",
     "mousemoved", "mousepressed", "mousereleased", "wheelmoved"
]

for x in a:
     c = x.capitalize()
     print("function gameState." + x + "()")
     print("    call(\"game" + c + "\", ...)")
     print("end")


