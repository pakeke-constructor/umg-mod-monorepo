


local Border = objects.Class("worldborder:Border")

local WHITE = {1,1,1,1}



local BORDER_LEIGHWAY = 200 -- threshhold where ents are teleported back


function Border:init(options)
    assert(options.centerX, "borders need centerX")
    assert(options.centerY, "borders need centerY")
    assert(options.width, "borders need width")
    assert(options.height, "borders need height")

    self.color = options.color or WHITE
    self.centerX = options.centerX
    self.centerY = options.centerY
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
    local dx = math.max(0, math.abs(x - self.centerX) - self.width/2)
    local dy = math.max(0, math.abs(y - self.centerY) - self.height/2)
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


borderGroup:onAdded(function(ent)
    local border = ent.border
    assert(type(border) == "table" and getmetatable(border) == Border, "border component must be border object")
end)


local function borderOrder(b1, b2)
    return (b1.width + b1.height) < (b2.width + b2.height)
end



local function moveEntToBorder(border, ent)
    local x, y = border:clampToWithinBorder(ent.x, ent.y)
    ent.x = x
    ent.y = y
end


local function dealWithEntity(borderBuffer, ent)
    local EPSILON = 0.01
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
        -- entity is outside our borders... lets see what we can do
        if closestBorder then
            if closestBorderDistance <= BORDER_LEIGHWAY then
                moveEntToBorder(closestBorder, ent)
            else
                -- too far out, just kill it
                base.server.kill(ent)
            end
        end
    end
end



local moveGroup = umg.group("x", "y", "vx", "vy")


local positionGroup = umg.group("x","y")





local sortedBorderBuffer = objects.Array()


local function getBorderBuffer()
    -- sort orders by size, its more efficient to check biggest borders first.
    local borderBuffer = objects.Array()
    for _, ent in ipairs(borderGroup) do
        borderBuffer:add(ent.border)
    end
    table.sort(borderBuffer, borderOrder)
    return borderBuffer
end


positionGroup:onAdded(function(ent)
    dealWithEntity(sortedBorderBuffer, ent)
end)



umg.on("@tick", function()
    if #borderGroup <= 0 then
        return -- No world borders? No problem
    end

    local borderBuffer = getBorderBuffer()
    sortedBorderBuffer = borderBuffer

    for _, ent in ipairs(moveGroup) do
        dealWithEntity(borderBuffer, ent)
    end
end)



end -- if server then



local worldborder = {}
worldborder.Border = Border

umg.expose("worldborder", worldborder)

