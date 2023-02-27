

local worldborder = {}


local borderColor = {0,0,0}



local borderNameToBorder = {
--[[
    [borderName]  =  border
]]
}



function worldborder.setColor(col)
    borderColor = col
end


function worldborder.getColor()
    return borderColor
end


local Border = base.Class("worldborder:Border")


function Border:init(options)

    assert(options.centerX, "borders need centerX")
    assert(options.centerY, "borders need centerY")
    assert(options.width, "borders need width")
    assert(options.height, "borders need height")
end



function worldborder.newBorder(options)


end



local function withinBorder(x,y, borderName)

end



function worldborder.entIsInBorder(ent, border)
    if border then
        -- could be a border name, or a border
        border = borderNameToBorder[border] or border

    else

    end
end

