

local Slab = require("Slab.Slab")

local dontInterceptEventHandlers = true
Slab.Initialize({}, dontInterceptEventHandlers)

local font = love.graphics.getFont()
Slab.GetStyle().API.PushFont(font)



umg.on("@quit", function()
	Slab.OnQuit()
end)


umg.on("@keypressed", function(key, scancode, isrepeat)
	Slab.OnKeyPressed(key, scancode, isrepeat)
end)

umg.on("@keyreleased", function(key, scancode)
	Slab.OnKeyReleased(key, scancode)
end)

umg.on("textinput", function(text)
	Slab.OnTextInput(text)
end)

umg.on("@wheelmoved", function(x, y)
	Slab.OnWheelMoved(x, y)
end)

umg.on("@mousemoved", function(x, y, dx, dy, istouch)
	Slab.OnMouseMoved(x, y, dx, dy, istouch)
end)

umg.on("@mousepressed", function( x, y, button, istouch, presses)
	Slab.OnMousePressed( x, y, button, istouch, presses)
end)

umg.on("@mousereleased", function( x, y, button, istouch, presses)
	Slab.OnMouseReleased( x, y, button, istouch, presses)
end)




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




local SLAB_SCALE_RATIO = 1/3

umg.on("@resize", function()
    Slab.SetScale(base.getUIScale() * SLAB_SCALE_RATIO)
end)


local docks = {
    "Left", "Bottom", "Right"
}


umg.on("@update", function(dt)
    Slab.Update(dt)
    Slab.SetScale(base.getUIScale() * SLAB_SCALE_RATIO)
    Slab.DisableDocks(docks)

    umg.call("slabUpdate")
end)



umg.on("mainDrawUI", function()
	love.graphics.push("all")
	love.graphics.setLineWidth(1)
    Slab.Draw()
	love.graphics.pop()
end)




-- We violate the export naming conventions here, because Slab itself violates the
-- naming conventions anyway.
-- It's better to stay consistent to the Slab examples :)
umg.expose("Slab", Slab)

