


local function check2Numbers(x, y)
    if type(x) == "number" and type(y) == "number" then
        return true
    end
    return false
end


local function checkDimensionVector(dvec)
    if type(dvec) == "table" then
        return dvec.x and dvec.y
    end
    return false
end



local function initPosition(ent, x, y, dimension)
    ent.x = x
    ent.y = y
    if dimensions.getOverseer(dimension) then
        -- if `dimension` is a valid dimension:
        ent.dimension = dimension
    end
end



local function initXY(ent, x, y, dim)
    if check2Numbers(x, y) then
        -- x, y is a position
        initPosition(ent, x, y, dim)
    elseif checkDimensionVector(x) then
        -- x is a dimension vector!
        local dvec = x
        initPosition(ent, dvec.x, dvec.y, dvec.dimension)
    end
end



umg.on("@entityInit", function(ent, x, y, dim)
    if ent.initXY then
        initXY(ent, x, y, dim)

    elseif ent.initVxVy then
        initXY(ent, x, y, dim)
        ent.vx = 0
        ent.vy = 0
    end
end)


