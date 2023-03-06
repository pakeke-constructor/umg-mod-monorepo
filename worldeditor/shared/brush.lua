
--[[

brush objects

All table keys with `_` are temporary, and specific to the runtime.


]]


local brushes = {}



local PointBrush = base.Class("wordeditor:PointBrush")
local SquareBrush = base.Class("worldeditor:SquareBrush")



function PointBrush:init(params)
    self.pointAction = params.pointAction
end

function PointBrush:apply(x, y)
    self.pointAction:apply(x, y)
end

PointBrush.name = "Point brush"
PointBrush.description = "Apply an action to a single point"

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

brushes.SquareBrush = SquareBrush






return brushes

