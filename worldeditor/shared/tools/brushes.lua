
--[[

brush objects

All table keys with `_` are temporary, and specific to the runtime.


]]

local constants = require("shared.constants")




local Brush = base.Class("worldeditor:Brush")
Brush.toolType = "Brush"


local PointBrush = base.Class("wordeditor:PointBrush", Brush)
local SquareBrush = base.Class("worldeditor:SquareBrush", Brush)

local brushes = {
    SquareBrush, PointBrush
}






function PointBrush:init(params)
    self.pointAction = params.pointAction
end

function PointBrush:apply(x, y)
    assert(server, "?")
    self.pointAction:apply(x, y)
end

function PointBrush:draw(x, y)
    assert(client, "?")
    love.graphics.setLineWidth(3)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("line", x, y, 6)
end

PointBrush.name = "Point brush"
PointBrush.description = "Apply an action to a single point"
PointBrush.useType = constants.USE_TYPE.DISCRETE


PointBrush.params = {
    {param = "pointAction", type = "PointAction"}
}










function SquareBrush:init(params)
    self.width = params.width
    self.height = params.height
    self.areaAction = params.areaAction
    self.lastUseArea = {
        x=0,y=0, w=0,h=0
    }
end

function SquareBrush:apply(x, y)
    assert(server, "?")
    local bottomX, bottomY = x-self.width/2, y-self.height/2
    local area = {
        x = bottomX, y = bottomY,
        w = self.width, h = self.height
    }
    self.areaAction:apply(area, self.lastUseArea)
    self.lastUseArea = area
end

function SquareBrush:draw(x, y)
    assert(client, "?")
    love.graphics.setColor(1,1,1)
    local botX, botY = x-self.width/2, y-self.height/2
    love.graphics.rectangle("line", botX, botY, self.width, self.height)
end


SquareBrush.name = "Square brush"
SquareBrush.description = "Apply an action to a square area"
SquareBrush.useType = constants.USE_TYPE.CONTINUOUS


SquareBrush.params = {
    {param = "width", type = "number", optional = false},
    {param = "height", type = "number", optional = false},
    {param = "areaAction", type = "AreaAction", optional = false}
}




return brushes