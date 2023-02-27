

local worldborder = {}



local Border = base.Class("worldborder:Border")

local WHITE = {1,1,1,1}



local BORDER_LEIGHWAY = 200 -- threshhold where ents are teleported back


function Border:init(options)
    assert(options.centerX, "borders need centerX")
    assert(options.centerY, "borders need centerY")
    assert(options.width, "borders need width")
    assert(options.height, "borders need height")
    assert(options.entity, "borders need an entity")

    self.entity = options.entity
    self.color = WHITE
    self.x = options.centerX - options.width / 2
    self.y = options.centerY - options.height / 2
    self.width = options.width
    self.height = options.height
end


function Border:setColor(col)
    self.color = col
end


function Border:getColor()
    return self.color
end



function Border:withinBorder(x,y)
    return self.x <= x and x <= (self.x+self.width)
        and self.y <= y and y <= (self.y+self.height)
end



function Border:entWithinBorder(ent)
    return self:withinBorder(ent.x, ent.y)
end



function Border:distanceFromBorderEdge(x,y)
    -- Uses manhattan distance  
    -- (pretty much the same as euclidean in this scenario)
    local dx = math.max(0, math.abs(x - self.centerX) - self.width)
    local dy = math.max(0, math.abs(y - self.centerY) - self.height)
    return dx + dy
end



function Border:clampToWithinBorder(x,y)
    x = math.min(math.max(self.x, x), self.x + self.width)
    y = math.min(math.max(self.y, y), self.y + self.height)
    return x, y
end




if server then

    
-- list of active world borders
local borderGroup = umg.group("border")


local moveGroup = umg.group("x", "y", "vx", "vy")


local function borderOrder(b1, b2)
    return (b1.width + b1.height) < (b2.width + b2.height)
end



local function moveEntToBorder(border, ent)
    local x, y = border:clampToWithinBorder(ent.x, ent.y)
    ent.x = x
    ent.y = y
end


umg.on("tick", function()
    if #borderGroup == 0 then
        return -- No world borders? No problem
    end

    local EPSILON = 0.01

    -- sort orders by size, its more efficient to check biggest borders first.
    local borderBuffer = base.Array()
    for _, border in ipairs(borderGroup) do
        borderBuffer:add(border)
    end
    table.sort(borderBuffer, borderOrder)

    for _, ent in ipairs(moveGroup) do
        local entWithin = false
        local closestBorder = nil
        local closestBorderDistance = math.huge

        for i=1, #borderBuffer do
            local border = borderBuffer[i]
            local distance = border:distanceFromBorderEdge(ent.x, ent.y)
            if distance < EPSILON then
                -- we're inside the border, this entity is fine.
                entWithin = true
                break 
            else
                if distance < closestBorderDistance then
                    closestBorderDistance = distance
                    closestBorder = border
                end
            end
        end

        if not entWithin then
            if closestBorder then
                moveEntToBorder(closestBorder, ent)
            end
        end
    end
end)


end



