

--[[

Inventory objects

]]


local Inventory = {}

local Inventory_mt = {__index = Inventory}


--[[
Since functions can't be sent over the network, (and the metatable contains
functions,)  we must register the metatable on both the client and the server,
so that it can be sent as a reference instead.
]]
register(Inventory_mt, "pakeke_inventory_mod:inventory_mt")


local DEFAULT_INVENTORY_COLOUR = {0.8,0.8,0.8}


local function new(inv)
    assert(inv.width, "Inventories must have a .width member!")
    assert(inv.height, "Inventories must have a .height member!")

    inv.inventory = {}
    inv.draw_x = 100
    inv.draw_y = 100

    if inv.color then
        assert(type(inv.color) == "table", "inventory colours must be {R,G,B} tables, with RGB values from 0-1!")
    else
        inv.color = DEFAULT_INVENTORY_COLOUR
    end

    inv.hovering = nil -- The current item that the player is hovering
    -- with the cursor.

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
    assert(item_ent.itemName)
    assert((not item_ent.description) or type(item_ent.description) == "string", "item entity descriptions must be strings")
    assert((not item_ent.stackSize) or type(item_ent.stackSize) == "number", "item entity stackSize must be a number")
    assert((not item_ent.maxStackSize) or type(item_ent.maxStackSize) == "number", "item entity maxStackSize must be a number")
end


function Inventory:set(x, y, item_ent)
    -- Should only be called on server.
    -- If `item_ent` is nil, then it removes the item from inventory.
    assertItem(item_ent)
    local i = self:getIndex(x,y)
    if exists(item_ent) then
        self.inventory[i] = item_ent
        if server then
            call("setInventoryItem", self, x, y, item_ent)
        end
    else
        self.inventory[i] = nil
    end
end



function Inventory:count(item_or_itemName)
    local itemName
    if (type(item_or_itemName) == "table") and item_or_itemName.itemName then
        itemName = item_or_itemName.itemName
    else
        assert(type(item_or_itemName) == "string", "Inventory:count(itemName) expects a string")
        itemName = item_or_itemName -- should be type `str`
    end

    local count = 0
    for x=1, self.width do
        for y=1, self.height do
            local check_item = self:get(x,y)
            if exists(check_item) then
                -- if its nil, there is no item there.
                if itemName == check_item.itemName then
                    count = count + check_item.stackSize
                end
            end
        end
    end
    return count
end


function Inventory:open()
    self.isOpen = true
end


function Inventory:close()
    self.isOpen = false
end


function Inventory:setOpen(bool)
    self.isOpen = bool
end


function Inventory:get(x, y)
    local i = self:getIndex(x, y)
    return self.inventory[i]
end


function Inventory:swap(other_inv, self_x, self_y, other_x, other_y)
    local item_self = self:get(self_x, self_y)
    local item_other = other_inv:get(other_x, other_y)
    other_inv:set(other_x, other_y, item_self)
    self:set(self_x, self_y, item_other)
end



--[[
Warning: 
Yucky, bad rendering code below this point!!!
Read at your own risk!  :-)
]]

local ITEM_SIZE = 16 -- item sizes are 16 by 16 pixels
local SQUARE_SIZE = 18 -- the size of inventory "pockets"
local PACKED_SQUARE_SIZE = 20 -- The size of packed inventory grid pockets

local BORDER_OFFSET = 4 -- border offset from inventory edge


function Inventory:drawItem(item_ent, x, y)
    --[[
        TODO:  Draw the stack number of the item entity!
    ]]
    local offset = (PACKED_SQUARE_SIZE - ITEM_SIZE) / 2
    local quad = assets.image[item_ent.image]
    local _,_, w,h = quad:getDimensions()
    if (w ~= 16 or h ~= 16) then
        error("Image dimensions for items must be 16 by 16! Not the case for this entity:\n" .. tostring(item_ent))
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
    graphics.rectangle("line", self.draw_x, self.draw_y, W, H)
    graphics.setColor(col)
    graphics.rectangle("fill", self.draw_x, self.draw_y, W, H)

    local offset = (PACKED_SQUARE_SIZE - SQUARE_SIZE) / 2

    for x = 0, self.width - 1 do
        for y = 0, self.height - 1 do
            local X = self.draw_x + x * PACKED_SQUARE_SIZE + BORDER_OFFSET + offset
            local Y = self.draw_y + y * PACKED_SQUARE_SIZE + BORDER_OFFSET + offset
            graphics.setColor(col[1] / 1.5, col[2] / 1.5, col[3] / 1.5)
            graphics.rectangle("fill", X, Y, SQUARE_SIZE, SQUARE_SIZE)
            if self:get(x, y) then
                self:drawItem(self:get(x,y), x, y)
            end
        end
    end

    local callbacks = self.owner.inventoryCallbacks
    if callbacks and callbacks.draw then
        callbacks.draw(self)
    end
    graphics.pop()
end


return new


