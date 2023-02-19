
local ShockWave = {
    --[[

Shockwave objects represented as a class, with :new and :update
and :draw methods.


    ]]
}

local mt = {__index = ShockWave}


local DEFAULT_THICKNESS = 4

local DEFAULT_START_RADIUS = 10
local DEFAULT_END_RADIUS = 100

local DEFAULT_DURATION = 0.4

local DEFAULT_FADERINGS = 5 -- the number of faded rings that follow the shockwave


local function new(sw)
    assert(type(sw) == "table", "Shockwave takes a table")
    assert(sw.x and sw.y, "Not given x,y position for shockwave!")

    sw.color = sw.color or {1,1,1,1}
    sw.thickness = sw.thickness or DEFAULT_THICKNESS
    sw.startRadius = sw.startRadius or DEFAULT_START_RADIUS
    sw.endRadius = sw.endRadius or DEFAULT_END_RADIUS
    sw.duration = sw.duration or DEFAULT_DURATION
    sw.fadeRings = sw.fadeRings or DEFAULT_FADERINGS
    
    sw.radius = sw.startRadius
    sw.dr = (sw.endRadius - sw.startRadius) / sw.duration
    return setmetatable(sw, mt)
end


function ShockWave:update(dt)
    self.radius = self.radius + (self.dr * dt)
    local opacity = 1-(self.radius-self.startRadius)/(self.endRadius-self.startRadius)
    self.colour[4] = opacity
    if self.dr < 0 then
        -- then the radius is running backwards
        if self.radius < self.endRadius then
            self.isFinished = true
        end
    else
        if self.radius > self.endRadius then
            self.isFinished = true
        end
    end
end





local setLineWidth = love.graphics.setLineWidth
local setColour = love.graphics.setColor

function ShockWave:draw()
    local lineThickness = self.thickness / self.fadeRings
    local dSign = self.dr / math.abs(self.dr)
    for i=1, self.fadeRings do
        local fade = i/self.fadeRings
        setColour(self.color[1], self.color[2], self.color[3], self.color[4]*fade)
        setLineWidth(lineThickness)
        love.graphics.circle("line", self.x, self.y, self.rad - (self.fadeRings-i)*dSign*lineThickness)
    end
end



return new

