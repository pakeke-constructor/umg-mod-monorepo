

local Slab = require("Slab.Slab")




local dontInterceptEventHandlers = true
Slab.Initialize({}, dontInterceptEventHandlers)

local font = love.graphics.getFont()
Slab.GetStyle().API.PushFont(font)



umg.on("@quit", function()
	Slab.OnQuit()
end)






local docks = {
    "Left", "Bottom", "Right"
}



local listener = input.Listener({priority = 100})


function listener:keypressed(key, scancode, isrepeat)
	Slab.OnKeyPressed(key, scancode, isrepeat)
end

function listener:keyreleased(key, scancode)
	Slab.OnKeyReleased(key, scancode)
end

function listener:textinput(text)
	Slab.OnTextInput(text)
end

function listener:wheelmoved(x, y)
	Slab.OnWheelMoved(x, y)
end

function listener:mousemoved(x, y, dx, dy, istouch)
	Slab.OnMouseMoved(x, y, dx, dy, istouch)
end


function listener:mousepressed( x, y, button, istouch, presses)
	Slab.OnMousePressed( x, y, button, istouch, presses)
end

function listener:mousereleased( x, y, button, istouch, presses)
	Slab.OnMouseReleased( x, y, button, istouch, presses)
end


local SLAB_SCALE_RATIO = 1/3

function listener:update(dt)
    Slab.Update(dt)
    Slab.SetScale(base.client.getUIScale() * SLAB_SCALE_RATIO)
    Slab.DisableDocks(docks)

    umg.call("slabUpdate", self)

    if not Slab.IsVoidHovered() then
        self:lockMouseButtons()
        self:lockMouseWheel()
		self:lockKeyboard()
    end
end




umg.on("postDrawUI", function()
	love.graphics.push("all")
	love.graphics.setLineWidth(1)
    Slab.Draw()
	love.graphics.pop()
end)




-- We violate the export naming conventions here, because Slab itself violates the
-- naming conventions anyway.
-- It's better to stay consistent to the Slab examples :)
umg.expose("Slab", Slab)

