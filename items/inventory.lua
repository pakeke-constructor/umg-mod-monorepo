

--[[

Inventory objects

]]



local Inventory = base.Class("items_mod:inventory")



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



local DEFAULT_BORDER_WIDTH = 10
local DEFAULT_SLOT_SIZE = 12
local DEFAULT_SLOT_SEPARATION = 2


function Inventory:init(options)
    assert(options.width, "Inventories must have a .width member!")
    assert(options.height, "Inventories must have a .height member!")
    self.width = options.width
    self.height = options.height

    -- size of inventory slots
    self.slotSize = options.slotSize or DEFAULT_SLOT_SIZE
    -- separation between inventory slots
    self.slotSeparation = options.slotSeparation or DEFAULT_SLOT_SEPARATION
    -- border offset from inventory edge
    self.borderWidth = options.borderWidth or DEFAULT_BORDER_WIDTH

    self.totalSlotSize = self.slotSize + self.slotSeparation

    self.autohold = options.autohold

    self.inventory = {}
    -- randomize initial draw position, to avoid overlap
    self.draw_x = math.random(0, 100)
    self.draw_y = math.random(0, 100)

    if options.color then
        assert(type(options.color) == "table", "inventory colours must be {R,G,B} tables, with RGB values from 0-1!")
        self.color = options.color
    else
        self.color = DEFAULT_INVENTORY_COLOUR
    end

    self.hovering_x = 1 -- The current item that the player is hovering over.
    self.hovering_y = 1

    self.isOpen = false

    self.owner = nil -- The entity that owns this inventory.
    -- Should be set by some system.
end



function Inventory:slotExists(x, y)
    local ent = self.owner
    if ent.inventorySlots then
        return ent.inventorySlots[y] and ent.inventorySlots[y][x]
    end
    return true
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



function Inventory:getHoveringItem()
    if self.hovering_x and self.hovering_y then
        return self:get(self.hovering_x, self.hovering_y)
    end
end



local function assertItem(item_ent)
    assert(item_ent.itemName, "items need an itemName component")
    assert((not item_ent.description) or type(item_ent.description) == "string", "item entity descriptions must be strings")
    assert((not item_ent.stackSize) or type(item_ent.stackSize) == "number", "item entity stackSize must be a number")
    assert((not item_ent.maxStackSize) or type(item_ent.maxStackSize) == "number", "item entity maxStackSize must be a number")
end


function Inventory:set(x, y, item_ent)
    -- Should only be called on server.
    -- If `item_ent` is nil, then it removes the item from inventory.
    
    if not self:slotExists(x, y) then
        return -- No slot.. can't do anything
    end

    local i = self:getIndex(x,y)
    if item_ent then
        assertItem(item_ent)
        item_ent.hidden = true
        item_ent.itemBeingHeld = true
        self.inventory[i] = item_ent
    else
        self.inventory[i] = nil
    end

    if server then
        -- We update the stacksize with this too.
        server.broadcast("setInventoryItem", self.owner, x, y, item_ent)
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
            if umg.exists(check_item) then
                -- if its nil, there is no item there.
                if itemName == check_item.itemName then
                    count = count + check_item.stackSize
                end
            end
        end
    end
    return count
end


function Inventory:contains(item_or_itemName)
    for x=1, self.width do
        for y=1, self.height do
            local check_item = self:get(x,y)
            if umg.exists(check_item) then
                -- if its nil, there is no item there.
                if item_or_itemName == check_item.itemName or item_or_itemName == check_item then
                    return true, x, y
                end
            end
        end
    end
    return false
end



function Inventory:getFreeSpace()
    local x,y
    -- else search for empty inventory space
    for i=1, self.width * self.height do
        x, y = self:getXY(i)
        if self:slotExists(x, y) then
            if not umg.exists(self.inventory[i]) then
                if self.inventory[i] then
                    -- delete non-existant entity
                    -- yeah... idk what happened here lol.
                    self.inventory[i] = nil
                end
                assert(self:getIndex(x,y) == i, "bug with inventory mod")--sanity check
                assert(not umg.exists(self:get(x,y)), "bug with inventory mod")
                return x,y
            end
        end
    end
end


function Inventory:getFreeSpaceFor(item)
    local x,y
    if item then
        -- then we first search for an item slot that is same type as `item`
        for i=1, self.width * self.height do
            x, y = self:getXY(i)
            if self:slotExists(x, y) then
                local item_ent = umg.exists(self.inventory[i]) and self.inventory[i]
                if item_ent then
                    if item_ent.itemName == item.itemName then
                        local remainingStackSize = (item_ent.maxStackSize or 1) - (item_ent.stackSize or 1)
                        if (remainingStackSize >= (item.stackSize or 1)) then
                            return x, y
                        end
                    end
                end
            end
        end
    end
end




function Inventory:canOpen(ent)
    assert(umg.exists(ent), "Inventory:canOpen(ent) takes an entity as first argument. (Where the entity is the one opening the inventory)")
    local owner = self.owner
    if owner.controllable or owner.controller then
        if not (owner.publicInventory or (owner == ent)) then
            return false
        end
    end
    if ent.inventoryCallbacks and ent.inventoryCallbacks.canOpen then
        local func = ent.inventoryCallbacks.canOpen
        if not func(self, ent) then
            return false
        end
    end
    return true
end



function Inventory:open()
    -- Should only be called on client-side
    umg.call("openInventory", self.owner)
    self.isOpen = true
end


function Inventory:close()
    -- Should only be called on client-side
    umg.call("closeInventory", self.owner)
    self.isOpen = false
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


function Inventory:withinBounds(mouse_x, mouse_y)
    -- returns true/false, depending on whether mouse_x or mouse_y is
    -- within the inventory interface
    local ui_scale = base.getUIScale()
    local x, y = mouse_x / ui_scale, mouse_y / ui_scale
    local x_valid = (self.draw_x - self.borderWidth <= x) and (x <= self.draw_x + (self.width * self.totalSlotSize) + self.borderWidth)
    local y_valid = (self.draw_y - self.borderWidth <= y) and (y <= self.draw_y + (self.height * self.totalSlotSize) + self.borderWidth)
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

    local bx, by = norm_x % self.totalSlotSize, norm_y % self.totalSlotSize
    local bo = (self.totalSlotSize - self.slotSize) / 2
    if bx > bo and bx < (self.totalSlotSize - bo) and by > bo and by < (self.totalSlotSize - bo) then
        local ix = floor(norm_x / self.totalSlotSize) + 1
        local iy = floor(norm_y / self.totalSlotSize) + 1
        if ix >= 1 and ix <= self.width and iy >= 1 and iy <= self.height then
            return ix, iy
        end
    end
end


local WHITE = {1,1,1}

function Inventory:drawItem(item_ent, x, y)
    love.graphics.push()
    love.graphics.setColor(item_ent.color or WHITE)

    local quad = client.assets.images[item_ent.image]
    local _,_, w,h = quad:getViewport()
    if (w ~= h) then
        error("Image width-height for items must be equal! Not the case for this entity:\n" .. tostring(item_ent))
    end
    local offset = (self.totalSlotSize - w) / 2
    local X = self.totalSlotSize * (x-1) + offset + self.draw_x
    local Y = self.totalSlotSize * (y-1) + offset + self.draw_y

    local scale = self.slotSize / w
    base.drawImage(quad, X + w/2, Y + w/2, 0, scale, scale)

    if item_ent.stackSize > 1 then
        -- Draw stack number
        love.graphics.push()
        love.graphics.translate(X-2,Y-2)
        love.graphics.scale(0.5)
        love.graphics.setColor(0,0,0,1)
        love.graphics.print(item_ent.stackSize, -1,0)
        love.graphics.print(item_ent.stackSize, 1,0)
        love.graphics.print(item_ent.stackSize, 0,1)
        love.graphics.print(item_ent.stackSize, 0,-1)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(item_ent.stackSize, 0,0)
        love.graphics.pop()
    end
    love.graphics.pop()
end





function Inventory:updateSlabUI()   
    local ent = self.owner
    for i, ui in ipairs(ent.inventoryUI) do
        local ent_id = ent.id
        local windowName = tostring(ent_id) .. "_" .. tostring(i)
        -- we must generate a unique string identifier due to Slab
        local scale = Slab.GetScale() / base.getUIScale()
        local winX = (self.draw_x + (ui.x-1) * self.totalSlotSize) / scale
        local winY = (self.draw_y + (ui.y-1) * self.totalSlotSize) / scale
        local winWidth = (self.totalSlotSize * ui.width) / scale
        local winHeight = (self.totalSlotSize * ui.height) / scale
        Slab.BeginWindow(windowName, {
            X = winX, Y = winY,
            W = winWidth, H = winHeight,
            BgColor = ui.color,
            AutoSizeWindow = false,
            AllowResize = false,
            AllowMove = false
        })
        ui.render(ent)
        Slab.EndWindow(windowName)
    end
end




function Inventory:setHoverXY(x,y)
    self.hovering_x = x
    self.hovering_y = y
    if client and self.autohold then
        local owner_ent = umg.exists(self.owner) and self.owner
        if owner_ent then
            client.send("setInventoryHoldItem", owner_ent, x, y)
        end
    end
end



local sqrt = math.sqrt



local function drawHighlights(draw_x, draw_y, W, H, r,g,b, offset, concave)
    offset = offset or 2
    local x = draw_x+offset
    local y = draw_y+offset
    local w,h = W-offset*2, H-offset*2

    if concave then
        love.graphics.setColor(sqrt(r)+0.1, sqrt(g)+0.1, sqrt(b)+0.1)
    else
        love.graphics.setColor(r*r-0.1, g*g-0.1, b*b-0.1)
    end
    love.graphics.line(x+w, y, x+w, y+h)
    love.graphics.line(x, y+h, x+w, y+h)

    if concave then
        love.graphics.setColor(r*r-0.1, g*g-0.1, b*b-0.1)
    else
        love.graphics.setColor(sqrt(r)+0.1, sqrt(g)+0.1, sqrt(b)+0.1)
    end
    love.graphics.line(x, y, x+w+1, y)
    love.graphics.line(x, y, x, y+h+1)
end


local function drawSlot(self, inv_x, inv_y, offset, color)
    local x, y = inv_x - 1, inv_y - 1 -- inventory is 1 indexed
    local X = math.floor(self.draw_x + x * self.totalSlotSize + offset)
    local Y = math.floor(self.draw_y + y * self.totalSlotSize + offset)

    love.graphics.setLineWidth(1)

    local r,g,b = color[1] / 1.5, color[2] / 1.5, color[3] / 1.5
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle("fill", X, Y, self.slotSize, self.slotSize)

    drawHighlights(X, Y, self.slotSize, self.slotSize, r,g,b, 1, true)

    -- love.graphics.setColor(0,0,0)
    -- love.graphics.rectangle("line", X, Y, self.slotSize, self.slotSize)

    if self.hovering_x == inv_x and self.hovering_y == inv_y then
        love.graphics.setLineWidth(4)
        love.graphics.setColor(0,0,0, 0.65)
        love.graphics.rectangle("line", X, Y, self.slotSize, self.slotSize)
    end

    if self:get(inv_x, inv_y) then
        local item = self:get(inv_x, inv_y)
        if umg.exists(item) then
            -- only draw the item if it exists.
            self:drawItem(item, inv_x, inv_y)
        else
            self:set(inv_x, inv_y, nil)
            -- woops!!! dunno what happened here lol!
        end
    end
end



function Inventory:drawUI()
    if not self.isOpen then
        return
    end

    love.graphics.push("all")
    -- No need to scale for UI- this should be done by draw system.

    local col = self.color or WHITE
    local W = self.width * self.totalSlotSize + self.borderWidth * 2
    local H = self.height * self.totalSlotSize + self.borderWidth * 2
    
    love.graphics.setLineWidth(2)
    
    -- Draw inventory body
    love.graphics.setColor(col) 
    love.graphics.rectangle("fill", self.draw_x - self.borderWidth, self.draw_y - self.borderWidth, W, H)

    local offset = self.slotSeparation / 2

    -- draw interior
    for x = 0, self.width - 1 do
        for y = 0, self.height - 1 do
            local inv_x, inv_y = x+1, y+1 -- inventory is 1-indexed
            if self:slotExists(inv_x, inv_y) then
                drawSlot(self, inv_x, inv_y, offset, col)
            end
        end
    end

    love.graphics.setLineWidth(2)
    drawHighlights(self.draw_x-self.borderWidth, self.draw_y-self.borderWidth, W, H, col[1],col[2],col[3])

    -- Draw outline
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", self.draw_x - self.borderWidth, self.draw_y - self.borderWidth, W, H)

    local callbacks = self.owner.inventoryCallbacks
    if callbacks and callbacks.draw then
        callbacks.draw(self)
    end
    
    love.graphics.pop()
end



function Inventory:drawHoverWidget(x, y)
    local item = self:get(x, y)
    if not umg.exists(item) then return end
    local mx, my = love.mouse.getPosition()
    local ui_scale = base.getUIScale()
    mx, my = mx / ui_scale, my / ui_scale
    love.graphics.push("all")
    love.graphics.setLineWidth(3)
    love.graphics.setColor(1,1,1,0.7)
    local ix = (x-1) * self.totalSlotSize + self.draw_x + self.totalSlotSize/2
    local iy = (y-1) * self.totalSlotSize + self.draw_y + self.totalSlotSize/2
    love.graphics.line(mx, my, ix, iy)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", mx,my, 2)
    love.graphics.pop()
end



return Inventory


