

--[[

Inventory objects

]]


local Inventory = {}

local Inventory_mt = {__index = Inventory}
-- TODO: Register this metatable with pckr somehow


local DEFAULT_INVENTORY_COLOUR = {0.8,0.8,0.8}


local function new(inv)
    assert(inv.width, "Inventories must have a .width member!")
    assert(inv.height, "Inventories must have a .height member!")

    inv.inventory = {}
    inv.x = 100
    inv.y = 100

    if inv.color then
        assert(type(inv.color) == "table", "inventory colours must be {R,G,B} tables, with RGB values from 0-1!")
    else
        inv.color = DEFAULT_INVENTORY_COLOUR
    end

    if inv.draw then
        assert(type(inv.draw) == "function", "inventory.draw ")
    end

    inv.isOpen = false

    inv.owner = nil -- The entity that owns this inventory.
    -- Should be set by some system.

    return setmetatable(inv, Inventory_mt)
end


function Inventory:mousepressed(x, y, butto)
    -- Should only be called on client side
end


function Inventory:withinBounds(mouse_x, mouse_y)
    -- returns true / false, depending on whether mouse_x or mouse_y is
    -- within the inventory interface
    return 
end


function Inventory:getIndex(x, y)
    -- private method
    return (self.width * x) + y
end


local floor = math.floor

function Inventory:getXY(index)
    return floor(index / self.width), index % self.width
end




local function assertItem(item_ent)
    assert(exists(item_ent))
    assert(item_ent.name)
    assert((not item_ent.description) or type(item_ent.description) == "string", "item entity descriptions must be strings")
    assert((not item_ent.stackSize) or type(item_ent.stackSize) == "number", "item entity stackSize must be a number")
    assert((not item_ent.maxStackSize) or type(item_ent.maxStackSize) == "number", "item entity maxStackSize must be a number")
end


function Inventory:set(x, y, item_ent)
    -- Should only be called on server
    assertItem(item_ent)
    local i = self:getIndex(x,y)
    self.inventory[i] = item_ent
    if server then
        call("setInventoryItem", self, x, y, item_ent)
    end
end



function Inventory:open()
    self.isOpen = true
end


function Inventory:close()
    self.isOpen = false
end


function Inventory:get(x, y)
    local i = self:getIndex(x, y)
    return self.inventory[i]
end



local ITEM_SIZE = 16 -- item sizes are 16 by 16 pixels
local SQUARE_SIZE = 18 -- the size of inventory "pockets"
local PACKED_SQUARE_SIZE = 20 -- The size of packed inventory grid pockets

local BORDER_OFFSET = 4 -- border offset from inventory edge


function Inventory:drawItem(item_ent, x, y)
    local offset = (PACKED_SQUARE_SIZE - ITEM_SIZE) / 2
    local quad = assets.image[item_ent.image]
    local _,_, w,h = quad:getDimensions()
    if (w ~= 16 or h ~= 16) then
        error("Image dimensions must be 16 by 16! (Not the case for this entity:)\n" .. tostring(item_ent))
    end
    local X = PACKED_SQUARE_SIZE * x + BORDER_OFFSET + offset
    local Y = PACKED_SQUARE_SIZE * y + BORDER_OFFSET + offset
    graphics.atlas:draw(quad, X, Y)
end


function Inventory:drawUI()
    if not self.isOpen then
        return
    end

    graphics.push("all")
    -- No need to scale for UI- this should be done by draw system.

    local col = self.color
    local W = self.width * PACKED_SQUARE_SIZE + BORDER_OFFSET * 2
    local H = self.height * PACKED_SQUARE_SIZE + BORDER_OFFSET * 2
    
    graphics.setColor(col[1] / 2, col[2] / 2, col[3] / 2)
    graphics.setLineWidth(4)
    graphics.rectangle("line", self.x, self.y, W, H)
    graphics.setColor(col)
    graphics.rectangle("fill", self.x, self.y, W, H)

    local offset = (PACKED_SQUARE_SIZE - SQUARE_SIZE) / 2

    for x = 0, self.width - 1 do
        for y = 0, self.height - 1 do
            local X = x * PACKED_SQUARE_SIZE + BORDER_OFFSET + offset
            local Y = y * PACKED_SQUARE_SIZE + BORDER_OFFSET + offset
            graphics.setColor(col[1] / 1.5, col[2] / 1.5, col[3] / 1.5)
            graphics.rectangle("fill", X, Y, SQUARE_SIZE, SQUARE_SIZE)
            if self:get(x, y) then
                self:drawItem(self:get(x,y), x, y)
            end
        end
    end

    if self.draw then
        self.draw()
    end
    graphics.pop()
end


return new 


