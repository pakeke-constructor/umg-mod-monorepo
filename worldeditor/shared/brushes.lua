
--[[

brush objects

All table keys with `_` are temporary, and specific to the runtime.


]]


local brushes = {}



local Brush = base.Class("worldeditor:Brush")
Brush.toolType = "Brush"

local PointBrush = base.Class("wordeditor:PointBrush", Brush)
local SquareBrush = base.Class("worldeditor:SquareBrush", Brush)



function PointBrush:init(params)
    self.pointAction = params.pointAction
end

function PointBrush:apply(x, y)
    self.pointAction:apply(x, y)
end

PointBrush.name = "Point brush"
PointBrush.description = "Apply an action to a single point"

PointBrush.params = {
    {param = "pointAction", type = "PointAction"}
}


brushes.PointBrush = PointBrush









function SquareBrush:init(params)
    self.width = params.width
    self.height = params.height
    self.areaAction = params.areaAction
end

function SquareBrush:apply(x, y)
    local bottomX, bottomY = x-self.width/2, y-self.height/2
    self.areaAction:apply(bottomX, bottomY, self.width, self.height)
end

SquareBrush.name = "Square brush"
SquareBrush.description = "Apply an action to a square area"

SquareBrush.params = {
    {param = "width", type = "number", optional = false},
    {param = "height", type = "number", optional = false},
    {param = "areaAction", type = "AreaAction", optional = false}
}


brushes.SquareBrush = SquareBrush






return brushes

