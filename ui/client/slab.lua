

local Slab = require("Slab.Slab")

local dontInterceptEventHandlers = true
Slab.Initialize({}, dontInterceptEventHandlers)



on("quit", function()
	Slab.OnQuit()
end)


on("keypressed", function(key, scancode, isrepeat)
	Slab.OnKeyPressed(key, scancode, isrepeat)
end)

on("keyreleased", function(key, scancode)
	Slab.OnKeyReleased(key, scancode)
end)

on("textinput", function(text)
	Slab.OnTextInput(text)
end)

on("wheelmoved", function(x, y)
	Slab.OnWheelMoved(x, y)
end)

on("mousemoved", function(x, y, dx, dy, istouch)
	Slab.OnMouseMoved(x, y, dx, dy, istouch)
end)

on("mousepressed", function( x, y, button, istouch, presses)
	Slab.OnMousePressed( x, y, button, istouch, presses)
end)

on("mousereleased", function( x, y, button, istouch, presses)
	Slab.OnMouseReleased( x, y, button, istouch, presses)
end)




on("resize", function()
    Slab.SetScale(base.getUIScale())
end)


local docks = {
    "Left", "Bottom", "Right"
}


on("update", function(dt)
    Slab.Update(dt)
    Slab.SetScale(base.getUIScale() / 2)
    Slab.DisableDocks(docks)

    call("slabUpdate")
end)



on("mainDrawUI", function()
    Slab.Draw()
end)




-- We violate the export naming conventions here, because Slab itself violates the
-- naming conventions anyway.
-- It's better to stay consistent to the Slab examples :)
export("Slab", Slab)

