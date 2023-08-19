

local max, min = math.max, math.min
local abs = math.abs


local WHITE = {1,1,1,1}



function checkBorder(options)
    local bd = {}

    assert(options.centerX, "borders need centerX")
    assert(options.centerY, "borders need centerY")
    assert(options.width, "borders need width")
    assert(options.height, "borders need height")

    bd.color = options.color or WHITE
    bd.centerX = options.centerX
    bd.centerY = options.centerY
    bd.x = options.centerX - options.width / 2
    bd.y = options.centerY - options.height / 2
    bd.width = options.width
    bd.height = options.height
    
    return bd
end






local function distanceFromBorderEdge(border, x,y)
    -- Uses manhattan distance  
    -- (pretty much the same as euclidean in this scenario)
    local dx = max(0, abs(x - border.centerX) - border.width/2)
    local dy = max(0, abs(y - border.centerY) - border.height/2)
    return dx + dy
end



local function clampToWithinBorder(border, x,y)
    x = min(max(border.x, x), border.x + border.width)
    y = min(max(border.y, y), border.y + border.height)
    return x, y
end




if server then



local function moveEntToBorder(border, ent)
    local x, y = clampToWithinBorder(border, ent.x, ent.y)
    ent.x = x
    ent.y = y
end



local function getBorder(ent)
    -- gets the worldborder for an entity inside a dimension
    local dimension = dimensions.getDimension(ent)
    local overseerEnt = dimensions.getOverseer(dimension)
    if overseerEnt and overseerEnt.border then
        return overseerEnt.border
    end
end



local function updateEntity(ent)
    local border = getBorder(ent)
    if not border then
        return -- we're all goods
    end

    local EPSILON = 0.01

    local distance = distanceFromBorderEdge(border, ent.x, ent.y)
    if distance > EPSILON then
        -- outside the border!
        --[[
            TODO: this is shit! we can do better.
                Perhaps emit a question if the entity is outside
                the border, before teleporting back?
        ]]
        moveEntToBorder(border, ent)
    end
end



--[[
    All the entities that have a border, and are overseeing a dimension
    (TODO: make this emptyGroup when empty groups are supported)
]]
local dimensionBorderGroup = umg.group("border", "overseeingDimension")


dimensionBorderGroup:onAdded(function(ent)
    ent.border = checkBorder(ent.border)
end)





local positionGroup = umg.group("x","y")

positionGroup:onAdded(function(ent)
    updateEntity(ent)
end)




local moveGroup = umg.group("x", "y", "vx", "vy")

-- we don't need to run every tick... running every 5 ticks will be fine.
scheduling.runEvery(5, "@tick", function()
    for _, ent in ipairs(moveGroup) do
        updateEntity(ent)
    end
end)



end -- if server then

