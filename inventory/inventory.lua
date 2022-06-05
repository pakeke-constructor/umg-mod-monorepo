

--[[

Inventory objects

]]


local Inventory = {}

local Inventory_mt = {__index = Inventory}


--[[
Since functions can't be sent over the network, (and the metatable contains
functions,)  we must register the metatable on both the client and the server,
so that it can be sent as a reference instead.

TODO: This should be done as a `class` instead.
Registering it direclty is a bit messy- it'd be cleaner to have a class() here.
]]
register(Inventory_mt, "pakeke_inventory_mod:inventory_mt")


local DEFAULT_INVENTORY_COLOUR = {0.8,0.8,0.8}




local function checkCallback(ent, callbackName, x, y, item)
    --[[
        returns true/false according to inventoryCallbacks component.
        (Only works on `canRemove` and `canAdd`!!!)
    ]]
    if ent.inventoryCallbacks and ent.inventoryCallbacks[callbackName] then
        item = item or ent.inventory:get(x,y)
        return ent.inventoryCallbacks[callbackName](ent.inventory, x, y, item)
    end
    return true -- return true otherwise (no callbacks)
end





local function new(inv)
    assert(inv.width, "Inventories must have a .width member!")
    assert(inv.height, "Inventories must have a .height member!")

    inv.inventory = {}
    -- randomize initial draw position, to avoid overlap
    inv.draw_x = math.random(0, 100)
    inv.draw_y = math.random(0, 100)

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




function Inventory:getIndex(x, y)
    -- private method
    return (self.height * (x-1)) + y
end


local floor = math.floor

function Inventory:getXY(index)
    local yy = (index-1) % self.height + 1
    return floor(index / self.height - 0.01) + 1, yy
end




local function assertItem(item_ent)
    assert(item_ent.itemName)
    assert((not item_ent.description) or type(item_ent.description) == "string", "item entity descriptions must be strings")
    assert((not item_ent.stackSize) or type(item_ent.stackSize) == "number", "item entity stackSize must be a number")
    assert((not item_ent.maxStackSize) or type(item_ent.maxStackSize) == "number", "item entity maxStackSize must be a number")
end


function Inventory:set(x, y, item_ent)
    -- Should only be called on server.
    -- If `item_ent` is nil, then it removes the item from inventory.
    
    if not checkCallback(self.owner, "slotExists", x, y) then
        return -- No slot.. can't do anything
    end

    local i = self:getIndex(x,y)
    if item_ent then
        assertItem(item_ent)
        self.inventory[i] = item_ent
    else
        self.inventory[i] = nil
    end
    if server then
        call("setInventoryItem", self, x, y, item_ent)
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


function Inventory:getFreeSpace()
    for i=1, self.width * self.height do
        if not exists(self.inventory[i]) then
            if self.inventory[i] then
                -- delete non-existant entity
                self.inventory[i] = nil
            end
            local x,y = self:getXY(i)
            assert(self:getIndex(x,y) == i)--sanity check
            assert(not exists(self:get(x,y)))
            return x,y
        end
    end
end


function Inventory:open()
    -- Should only be called on client-side
    call("openInventory", self, self.owner)
    self.isOpen = true
end


function Inventory:close()
    -- Should only be called on client-side
    call("closeInventory", self, self.owner)
    self.isOpen = false
end


function Inventory:setOpen(bool)
    -- Should only be called client-side
    if bool == self.isOpen then
        return
    end
    if bool then
        call("openInventory", self, self.owner)
    else
        call("closeInventory", self, self.owner)
    end
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

local BORDER_OFFSET = 6 -- border offset from inventory edge



function Inventory:withinBounds(mouse_x, mouse_y)
    -- returns true/false, depending on whether mouse_x or mouse_y is
    -- within the inventory interface
    if not (base and base.getUIScale) then
        error("Inventory mod requires base mod to be loaded!")
    end
    local ui_scale = base.getUIScale()
    local x, y = mouse_x / ui_scale, mouse_y / ui_scale
    local x_valid = (self.draw_x - BORDER_OFFSET <= x) and (x <= self.draw_x + (self.width * PACKED_SQUARE_SIZE) + BORDER_OFFSET)
    local y_valid = (self.draw_y - BORDER_OFFSET <= y) and (y <= self.draw_y + (self.height * PACKED_SQUARE_SIZE) + BORDER_OFFSET)
    return x_valid and y_valid
end


function Inventory:getBucket(mouse_x, mouse_y)
    if not (base and base.getUIScale)  then
        error("Inventory mod requires base mod to be loaded!")
    end
    local ui_scale = base.getUIScale()
    local x, y = mouse_x / ui_scale, mouse_y / ui_scale
    local norm_x = x - self.draw_x 
    local norm_y = y - self.draw_y

    local bx, by = norm_x % PACKED_SQUARE_SIZE, norm_y % PACKED_SQUARE_SIZE
    local bo = (PACKED_SQUARE_SIZE - SQUARE_SIZE) / 2
    if bx > bo and bx < (PACKED_SQUARE_SIZE - bo) and by > bo and by < (PACKED_SQUARE_SIZE - bo) then
        local ix = floor(norm_x / PACKED_SQUARE_SIZE) + 1
        local iy = floor(norm_y / PACKED_SQUARE_SIZE) + 1
        if ix >= 1 and ix <= self.width and iy >= 1 and iy <= self.height then
            return ix, iy
        end
    end
end


local WHITE = {1,1,1}

function Inventory:drawItem(item_ent, x, y)
    --[[
        TODO:  Draw the stack number of the item entity!
    ]]
    graphics.push()
    graphics.setColor(item_ent.color or WHITE)
    local offset = (PACKED_SQUARE_SIZE - ITEM_SIZE) / 2
    local quad = assets.images[item_ent.image]
    local _,_, w,h = quad:getViewport()
    if (w ~= 16 or h ~= 16) then
        error("Image dimensions for items must be 16 by 16! Not the case for this entity:\n" .. tostring(item_ent))
    end
    local X = PACKED_SQUARE_SIZE * (x-1) + offset + self.draw_x
    local Y = PACKED_SQUARE_SIZE * (y-1) + offset + self.draw_y
    graphics.atlas:draw(quad, X, Y)
    graphics.push()
    graphics.translate(X-2,Y-2)
    graphics.scale(0.5)
    graphics.setColor(0,0,0,1)
    graphics.print(item_ent.stackSize, -1,0)
    graphics.print(item_ent.stackSize, 1,0)
    graphics.print(item_ent.stackSize, 0,1)
    graphics.print(item_ent.stackSize, 0,-1)
    graphics.setColor(1,1,1,1)
    graphics.print(item_ent.stackSize, 0,0)
    graphics.pop()
    graphics.pop()
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
    graphics.rectangle("line", self.draw_x - BORDER_OFFSET, self.draw_y - BORDER_OFFSET, W, H)
    graphics.setColor(col)
    graphics.rectangle("fill", self.draw_x - BORDER_OFFSET, self.draw_y - BORDER_OFFSET, W, H)

    local offset = (PACKED_SQUARE_SIZE - SQUARE_SIZE) / 2

    for x = 0, self.width - 1 do
        for y = 0, self.height - 1 do
            local X = self.draw_x + x * PACKED_SQUARE_SIZE + offset
            local Y = self.draw_y + y * PACKED_SQUARE_SIZE + offset
            graphics.setColor(col[1] / 1.5, col[2] / 1.5, col[3] / 1.5)
            graphics.rectangle("fill", X, Y, SQUARE_SIZE, SQUARE_SIZE)
            if self:get(x + 1, y + 1) then
                self:drawItem(self:get(x + 1, y + 1), x + 1, y + 1)
            end
        end
    end

    local callbacks = self.owner.inventoryCallbacks
    if callbacks and callbacks.draw then
        callbacks.draw(self)
    end
    graphics.pop()
end



function Inventory:drawHoldWidget(x, y)
    local item = self:get(x, y)
    if not exists(item) then return end
    local mx, my = mouse.getPosition()
    local ui_scale = base.getUIScale()
    mx, my = mx / ui_scale, my / ui_scale
    graphics.push("all")
    graphics.setLineWidth(3)
    graphics.setColor(1,1,1,0.7)
    local ix = (x-1) * PACKED_SQUARE_SIZE + self.draw_x + PACKED_SQUARE_SIZE/2
    local iy = (y-1) * PACKED_SQUARE_SIZE + self.draw_y + PACKED_SQUARE_SIZE/2
    graphics.line(mx, my, ix, iy)
    graphics.setColor(1,1,1)
    graphics.circle("fill", mx,my, 2)
    graphics.pop()
end



return new


