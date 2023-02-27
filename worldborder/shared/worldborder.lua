

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
    assert(options.name, "borders need a name")

    self.x = options.centerX - options.width / 2
    self.y = options.centerY - options.height / 2
    self.width = options.width
    self.height = options.height
    self.name = options.name

    borderNameToBorder[options.name] = self
end



function Border:withinBorder(x,y)
    return self.x <= x and x <= (self.x+self.width)
        and self.y <= y and y <= (self.y+self.height)
end




function worldborder.newBorder(options)


end





function worldborder.entIsInBorder(ent, border)
    if border then
        -- could be a border name, or a border
        border = borderNameToBorder[border] or border

    else

    end
end

