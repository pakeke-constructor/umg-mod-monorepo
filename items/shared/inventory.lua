

--[[

Inventory objects.

Inventory objects can be extended, to create cooler, custom inventories.
You can also override any part of the rendering, to create custom
inventory backgrounds, custom slots, etc etc.

]]

require("items_events")
require("items_questions")

local SlotHandle = require("shared.slot_handle")


local Inventory = objects.Class("items_mod:inventory")


local updateStackSize
if server then
    updateStackSize = require("server.update_stacksize")
end

local openInventories
if client then
    openInventories = require("client.open_inventories")
end



local assert2Numbers = typecheck.assert("number", "number")

local DEFAULT_INVENTORY_COLOUR = {0.8,0.8,0.8}


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

    self.inventory = {}  -- Array where the items are actually stored.

    -- randomize initial draw position, to avoid overlap
    self.draw_x = math.random(0, 100)
    self.draw_y = math.random(0, 100)

    if options.color then
        assert(type(options.color) == "table", "inventory colours must be {R,G,B} tables, with RGB values from 0-1!")
        self.color = options.color
    else
        self.color = DEFAULT_INVENTORY_COLOUR
    end

    self.is_open = false

    self.owner = nil -- The entity that owns this inventory.
    -- Should be set by some system.
end



function Inventory:setup(ent)
    --[[ 
    This is called automatically by the main items system on the server.
    if you intend to use the inventory immediately after creation,
    call this function. 
    ]]
    if self.owner and self.owner ~= ent then
        error("owner is already set to a different inventory!")
    end

    self.owner = ent
end



function Inventory:slotExists(x, y)
    -- if out of bounds, return false
    if (x < 1 or x > self.width) or (y < 1 or y > self.height) then
        return false
    end

    local ent = self.owner
    if ent.inventorySlots then
        return ent.inventorySlots[y] and ent.inventorySlots[y][x]
    end
    return true
end




function Inventory:getIndex(slotX, slotY)
    -- internally, inventory is just an array.
    -- This method gets index in the inventory array, given (slotX, slotY)
    return (self.height * (slotX-1)) + slotY
end


local floor = math.floor



function Inventory:getSlot(index)
    -- gets slot position from an index
    local yy = (index-1) % self.height + 1
    return floor(index / self.height - 0.01) + 1, yy
end




local function assertItem(item_ent)
    assert(item_ent.itemName, "items need an itemName component")
    assert((not item_ent.description) or type(item_ent.description) == "string", "item entity descriptions must be strings")
    assert((not item_ent.stackSize) or type(item_ent.stackSize) == "number", "item entity stackSize must be a number")
    assert((not item_ent.maxStackSize) or type(item_ent.maxStackSize) == "number", "item entity maxStackSize must be a number")
end




local function signalMoveToSlot(self, slotX, slotY, item_ent)
    -- calls appropriate callbacks for item addition
    local slotHandle = self:getSlotHandle(slotX,slotY)
    if slotHandle then
        slotHandle:onItemAdded(item_ent)
    end
    umg.call("items:itemMoved", self.owner, item_ent, slotX, slotY)
end


local function signalRemoveFromSlot(self, slotX, slotY, item_ent)
    -- calls appropriate callbacks for item removal
    local slotHandle = self:getSlotHandle(slotX,slotY)
    if slotHandle then
        slotHandle:onItemRemoved(item_ent)
    end
    umg.call("items:itemRemoved", self.owner, item_ent, slotX, slotY)
end




function Inventory:_rawset(x, y, item_ent)
    --[[
        This is a helper function, and SHOULDN'T BE CALLED!!!!
        CALL THIS FUNCTION AT YOUR OWN RISK!
    ]]
    if not self:slotExists(x, y) then
        return -- No slot.. can't do anything
    end

    local i = self:getIndex(x,y)
    -- TODO: Is it fine to call these callbacks here???
    if item_ent then
        assertItem(item_ent)
        self.inventory[i] = item_ent
    else
        self.inventory[i] = nil
    end
end


--[[
    puts an item directly into an inventory.
    BIG WARNING:
    This is a very low-level function, and IS VERY DANGEROUS TO CALL!
    If you want to move inventory items around, take a look at the
    :move  and  :swap  methods.

    Calling this function willy-nilly will make it so the same item
        may be duplicated across multiple inventories.
]]
function Inventory:set(slotX, slotY, item)
    -- DON'T CALL THIS FUNCTION IF YOU ARE UNSURE!!!
    -- Seriously, please!!! Don't be a fakken muppet
    assert(server, "Can only be called on server")
    assert2Numbers(slotX, slotY)

    -- If `item_ent` is nil, then it removes the item from inventory.
    self:_rawset(slotX, slotY, item)
    server.broadcast("setInventoryItem", self.owner, slotX, slotY, item)
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



function Inventory:getEmptySlot()
    -- Returns the slotX,Y of an empty inventory slot
    for x=1, self.width do
        for y=1, self.height do
            local i = self:getIndex(x, y)
            if self:slotExists(x, y) then
                if not umg.exists(self.inventory[i]) then
                    assert(self:getIndex(x,y) == i, "bug with inventory mod")--sanity check
                    assert(not umg.exists(self:get(x,y)), "bug with inventory mod")
                    return x,y
                end
            end
        end
    end
end





local hasRemoveAuthorityTc = typecheck.assert("entity", "number", "number")

function Inventory:hasRemoveAuthority(controlEnt, slotX, slotY)
    --[[
        whether the controlEnt has the authority to remove the
        item at slotX, slotY
    ]]
    hasRemoveAuthorityTc(controlEnt, slotX, slotY)
    if not self:canBeOpenedBy(controlEnt) then
        return
    end

    local item = self:get(slotX, slotY)
    if not item then
        -- cannot remove an empty slot.
        return false 
    end

    local isBlocked = umg.ask("items:isItemRemovalBlocked", controlEnt, self.owner, slotX, slotY)
    return not isBlocked
end



local hasAddAuthorityTc = typecheck.assert("entity", "table", "number", "number")

function Inventory:hasAddAuthority(controlEnt, itemToBeAdded, slotX, slotY)
    --[[
        whether the controlEnt has the authority to add
        `item` to the slot (slotX, slotY)
    ]]
    hasAddAuthorityTc(controlEnt, itemToBeAdded, slotX, slotY)
    if not self:canBeOpenedBy(controlEnt) then
        return
    end

    -- TODO: rename this question, it's terribly named
    local isBlocked = umg.ask("items:isItemAdditionBlocked", controlEnt, self.owner, itemToBeAdded, slotX, slotY)
    return not isBlocked
end




local canAddToSlotTc = typecheck.assert("number", "number", "entity", "number?")

-- returns `true` if we can add `count` stacks of item to (slotx, sloty)
-- false otherwise.
function Inventory:canAddToSlot(slotX, slotY, item, count)
    canAddToSlotTc(slotX, slotY, item, count)
    if not self:slotExists(slotX, slotY) then
        return nil
    end

    -- `count` is the number of items that we want to add. (defaults to the full stackSize of item)
    count = (count or item.stackSize) or 1

    local i = self:getIndex(slotX, slotY)
    local item_ent = umg.exists(self.inventory[i]) and self.inventory[i]
    if item_ent then
        if item_ent.itemName == item.itemName then
            local remainingStackSize = (item_ent.maxStackSize or 1) - count
            if (remainingStackSize >= count) then
                -- the target slot is the same item type, and there is free space in the stack
                return true
            end
        end
    else
        return true -- slot is empty, so its fine to add
    end
end


--[[
    Finds an inventory slot that will fit `item`

    count is the number of items to take from the stack. (default = item.stackSize)
]]
function Inventory:findAvailableSlot(item, count)
    for x=1, self.width do
        for y=1, self.height do
            if self:canAddToSlot(x, y, item, count) then
                -- slot (x,y) is available!
                return x, y 
            end
        end
    end
    return false -- can't add
end





local moveSwapTc = typecheck.assert("number", "number", "table", "number", "number")


local moveStackCountTc = typecheck.assert("table", "number", "table?")

local function getMoveStackCount(item, count, targetItem)
    moveStackCountTc(item, count, targetItem)
    --[[
        gets how many items can be moved from item to targetItem
    ]]
    local stackSize = item.stackSize or 1
    count = math.max(0, count or stackSize)

    if targetItem then
        local targSS = targetItem.stackSize or 1
        local targMaxSS = targetItem.maxStackSize or 1
        local stacksLeft = targMaxSS - targSS
        local maxx = item.maxStackSize or 1
        return math.min(math.min(maxx, count), stacksLeft)
    else
        local maxx = item.maxStackSize or 1
        return math.min(maxx, count)
    end
end


local function moveIntoTakenSlot(self, slotX, slotY, otherInv, otherSlotX, otherSlotY, count)
    local targ = otherInv:get(otherSlotX, otherSlotY)
    local item = self:get(slotX, slotY)
    count = getMoveStackCount(item, count, targ)

    local newStackSize = item.stackSize - count
    if newStackSize <= 0 then
        -- delete src item, since all it's stacks are gone
        self:remove(slotX, slotY)
        item:delete()
    else
        -- else, we reduce the src item stacks
        item.stackSize = newStackSize
        updateStackSize(item)
    end
    -- add stacks to the target item 
    targ.stackSize = targ.stackSize + count
    updateStackSize(item)
end



local function moveIntoEmptySlot(self, slotX, slotY, otherInv, otherSlotX, otherSlotY, count)
    local item = self:get(slotX, slotY)
    count = getMoveStackCount(item, count)

    if count <= 0 then return
        false -- failure, no space
    end

    if count < item.stackSize then
        -- then we are only moving part of the stack; so we must create a copy
        local newItem = item:deepClone()
        newItem.stackSize = count
        item.stackSize = item.stackSize - count
        otherInv:add(otherSlotX, otherSlotY, newItem)
        updateStackSize(item)
    else
        -- we are moving the whole item
        self:remove(slotX, slotY)
        otherInv:add(otherSlotX, otherSlotY, item)
    end
    return true -- success
end



local moveTc = typecheck.assert("number", "number", "table", "number?")

--[[
    attempts to move the item at slotX, slotY in `self`
    into otherInv
]]
function Inventory:move(slotX, slotY, otherInv, count)
    moveTc(slotX, slotY, otherInv, count)
    local item = self:get(slotX, slotY)
    local otherX, otherY = otherInv:findAvailableSlot(item, count)
    if otherX and otherY then
        return self:moveToSlot(slotX, slotY, otherInv, otherX, otherY, count)
    end
    return false
end



function Inventory:moveToSlot(slotX, slotY, otherInv, otherSlotX, otherSlotY, count)
    --[[
        moves an item from one inventory to another.
        Can also specify the `stackSize` argument to only send part of a stack.
    ]]
    assert(server, "only available on server")
    moveSwapTc(slotX, slotY, otherInv, otherSlotX, otherSlotY, count)

    local item = self:get(slotX, slotY)
    local stackSize = item.stackSize or 1
    count = math.min(count or stackSize, stackSize)

    local targ = otherInv:get(otherSlotX, otherSlotY)

    if targ then
        if otherInv:canAddToSlot(otherSlotX, otherSlotY, item, count) then
            moveIntoTakenSlot(self, slotX, slotY, otherInv, otherSlotX, otherSlotY, count)
            return true -- success
        end
    else
        moveIntoEmptySlot(self, slotX, slotY, otherInv, otherSlotX, otherSlotY, count)
        return true -- success
    end

    return false -- failed
end



function Inventory:swap(slotX, slotY, otherInv, otherSlotX, otherSlotY)
    --[[
        swaps two items in inventories.
    ]]
    assert(server, "only available on server")
    moveSwapTc(slotX, slotY, otherInv, otherSlotX, otherSlotY)
    local item = self:get(slotX, slotY)
    local otherItem = otherInv:get(otherSlotX, otherSlotY)
    local isDifferent = (slotX ~= otherSlotX) or (slotY ~= otherSlotY) or (self ~= otherInv)

    if not isDifferent then
        return -- we aren't moving anything!
    end

    self:remove(slotX, slotY)
    otherInv:remove(otherSlotX, otherSlotY)

    self:add(slotX, slotY, otherItem)
    otherInv:add(otherSlotX, otherSlotY, item)
end



local addTc = typecheck.assert("number", "number", "voidentity")
function Inventory:add(slotX, slotY, item)
    -- Directly adds an item to an inventory.
    -- WARNING: THIS METHOD IS QUITE DANGEROUS TO CALL!!!
    -- `item` must NOT be in any other inventory!
    -- If item is in another inv, the item-entity will be duplicated across BOTH inventories!!!
    addTc(slotX, slotY, item)
    if self:get(slotX, slotY) then
        error("slot was taken: " .. tostring(slotX) .. ", " .. tostring(slotY))
    end
    signalMoveToSlot(self, slotX, slotY, item)
    self:set(slotX, slotY, item)
end


function Inventory:remove(slotX, slotY)
    -- Directly removes an item from a slot in an inventory.
    -- This is kinda like deleting the item.
    local item = self:get(slotX, slotY)
    if umg.exists(item) then
        signalRemoveFromSlot(self, slotX, slotY, item)
    end
    self:set(slotX, slotY, nil)
end




function Inventory:canBeOpenedBy(ent)
    --[[
        we ask two questions here,
        one for whether the inventory can be opened,
        another for whether the inventory is locked.

        This provides a lot of flexibility.
    ]]
    assert(umg.exists(ent), "takes an entity as first argument. (Where the entity is the one opening the inventory)")

    local canOpen = umg.ask("items:canOpenInventory", ent, self)
    if canOpen then
        local isLocked = umg.ask("items:isInventoryLocked", ent, self)
        if not isLocked then
            return true
        end
    end
end



function Inventory:open()
    assert(client, "Only available client-side")
    umg.call("items:openInventory", self.owner)
    openInventories.open(self)
    self.is_open = true
end


function Inventory:close()
    assert(client, "Only available client-side")
    umg.call("items:closeInventory", self.owner)
    openInventories.close(self)
    self.is_open = false
end



function Inventory:isOpen()
    return self.is_open
end




function Inventory:get(x, y)
    assert2Numbers(x, y)
    local i = self:getIndex(x, y)
    return self.inventory[i]
end







-- private method
local function getSlotHandles(self)
    --[[
        a lot of inventories don't need slotHandle, so we create
        the data structure in a lazy fashion:
    ]]
    if self.slotHandles then
        return self.slotHandles
    end
    self.slotHandles = {--[[
        [slotX] -> {
            [slotY] -> slotHandle
        }
    ]]}
    return self.slotHandles
end


function Inventory:getSlotHandle(slotX, slotY)
    local slotHandles = self.slotHandles
    local arr = slotHandles and slotHandles[slotX]
    return arr and arr[slotY]
end


function Inventory:setSlotHandle(slotX, slotY, slotHandle)
    --[[
        sets a slot handle at (slotX, slotY) to slotHandle
    ]]
    assert2Numbers(slotX, slotY)
    if not SlotHandle.isInstance(slotHandle) then
        error("Not an instance of SlotHandle: " .. tostring(slotHandle))
    end

    if self:getSlotHandle(slotX,slotY) then
        -- error, since we are overwriting existing:
        error("Overwriting existing slot handle at: " .. tostring(slotX) .. ", " .. tostring(slotY))
    end

    slotHandle:setSlotPosition(slotX, slotY)

    -- else set new slotHandle:
    local slotHandles = getSlotHandles(self)
    local arr = slotHandles[slotX] or {}
    slotHandles[slotX] = arr
    arr[slotY] = slotHandle
end











--[[
Warning: 
Yucky, bad rendering code below this point!!!
Read at your own risk!  :-)
]]


function Inventory:withinBounds(mouse_x, mouse_y)
    -- returns true/false, depending on whether mouse_x or mouse_y is
    -- within the inventory interface
    local ui_scale = rendering.getUIScale()
    local mx, my = mouse_x / ui_scale, mouse_y / ui_scale
    local x,y,w,h = self:getDrawBounds()
    local x_valid = (x <= mx) and (mx <= x+w)
    local y_valid = (y <= my) and (my <= y+h)
    return x_valid and y_valid
end


function Inventory:getSlot(mouse_x, mouse_y)
    local ui_scale = rendering.getUIScale()
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

    local offset = (self.totalSlotSize - w) / 2
    local X = self.totalSlotSize * (x-1) + offset + self.draw_x
    local Y = self.totalSlotSize * (y-1) + offset + self.draw_y

    local drawX, drawY = X + w/2, Y + w/2
    local maxSize = math.max(w, h)
    local scale = self.slotSize / maxSize
    rendering.drawImage(quad, drawX, drawY, 0, scale, scale)

    local holder_ent = self.owner
    umg.call("items:drawInventoryItem", holder_ent, item_ent, drawX, drawY, self.slotSize)

    if (item_ent.stackSize or 1) > 1 then
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


local function updateInventoryUI(self)
    local ent = self.owner
    for i, ui in ipairs(ent.inventoryUI) do
        local ent_id = ent.id
        local windowName = "inventory:" .. tostring(ent_id) .. "_" .. tostring(i)
        -- we must generate a unique string identifier due to Slab
        local scale = Slab.GetScale() / rendering.getUIScale()
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



local descriptionArgs = {Color = {0.56,0.56,0.56}}
local TOOLTIP_DELTA = 3

local function updateItemTooltip(itemEnt, mx, my)
    Slab.BeginWindow("inventory.itemInfo", {
        X = mx+TOOLTIP_DELTA, Y = my+TOOLTIP_DELTA,
        AllowResize = false
    })
 
    Slab.Text(itemEnt.itemName)
    if itemEnt.itemDescription then
        Slab.Text(itemEnt.itemDescription, descriptionArgs)
    end

    umg.call("items:displayItemTooltip", itemEnt)

    Slab.EndWindow()
end




function Inventory:updateSlabUI() 
    local ent = self.owner
    if ent.inventoryUI then
        -- custom UI stuff
        updateInventoryUI(self)
    end

    local mx, my = love.mouse.getPosition()
    local slotx, sloty = self:getSlot(mx,my)
    if slotx then
        local item = self:get(slotx, sloty)
        if umg.exists(item) then
            updateItemTooltip(item, mx, my)
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


function Inventory:drawSlot(inv_x, inv_y, offset, color)
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






local EXIT_BUTTON_SIZE = 8
local EXIT_BUTTON_BORDER = 3

local EXTRA_TOP_BORDER = 8

function getExitButtonBounds(self)
    local x,y,w,h = self:getDrawBounds()
    local bx = x + w - EXIT_BUTTON_SIZE - EXIT_BUTTON_BORDER
    local by = y + EXIT_BUTTON_BORDER
    return bx,by, EXIT_BUTTON_SIZE,EXIT_BUTTON_SIZE
end


function Inventory:withinExitButtonBounds(mouse_x, mouse_y)
    -- returns true/false, depending on whether mouse_x or mouse_y is
    -- within the exit button region
    local ui_scale = rendering.getUIScale()
    local mx, my = mouse_x / ui_scale, mouse_y / ui_scale
    local x,y,w,h = getExitButtonBounds(self)
    local x_valid = (x <= mx) and (mx <= x+w)
    local y_valid = (y <= my) and (my <= y+h)
    return x_valid and y_valid
end



function Inventory:getDrawBounds()
    assert(client, "Shouldn't be called serverside")
    -- total width/height of inventory
    local w = self.width * self.totalSlotSize + self.borderWidth * 2
    local h = self.height * self.totalSlotSize + self.borderWidth * 2 + EXTRA_TOP_BORDER

    -- the top-left coords of inventory
    local x = self.draw_x - self.borderWidth
    local y = self.draw_y - self.borderWidth - EXTRA_TOP_BORDER
    return x,y, w,h
end





function Inventory:drawExitButton(x,y,w,h)
    love.graphics.setLineWidth(1)
    local col = self.color or WHITE
    love.graphics.setColor(col)
    love.graphics.rectangle("fill", x,y,w,h)

    love.graphics.setColor(col[1]/2, col[2]/2, col[3]/2)
    love.graphics.line(x,y, x+w,y+h)
    love.graphics.line(x+w,y, x,y+h)

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", x,y,w,h)
end




local function getInventoryName(self)
    local ent = self.owner
    return (ent.inventoryName or self.name)
end



local INVENTORY_NAME_OFFSET = 4

function Inventory:drawInventoryName()
    local name = getInventoryName(self)
    if not name then
        return
    end

    local x,y,_,_ = self:getDrawBounds()
    local X = x + INVENTORY_NAME_OFFSET
    local Y = y + INVENTORY_NAME_OFFSET
    local font = love.graphics.getFont()
    local w,h = font:getWidth(name), font:getHeight()
    local scale = EXTRA_TOP_BORDER / h
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(name, X,Y,0,scale,scale)
end



function Inventory:drawHoverWidget(slotX, slotY)
    --[[
        if the player is picking up an item,
        and about to move it, this stuff will be drawn!
    ]]
    local item = self:get(slotX, slotY)
    if not umg.exists(item) then return end
    local mx, my = love.mouse.getPosition()
    local ui_scale = rendering.getUIScale()
    mx, my = mx / ui_scale, my / ui_scale
    love.graphics.push("all")
    love.graphics.setLineWidth(3)
    love.graphics.setColor(1,1,1,0.7)
    local ix = (slotX-1) * self.totalSlotSize + self.draw_x + self.totalSlotSize/2
    local iy = (slotY-1) * self.totalSlotSize + self.draw_y + self.totalSlotSize/2
    love.graphics.line(mx, my, ix, iy)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", mx,my, 2)
    love.graphics.pop()
end



function Inventory:drawBackground(x, y, w, h)
    -- Draw inventory body
    local col = self.color or WHITE
    love.graphics.setColor(col) 
    love.graphics.rectangle("fill", x, y, w, h)
end


function Inventory:drawForeground(x, y, w, h)
    local col = self.color or WHITE
    love.graphics.setLineWidth(2)
    drawHighlights(x, y, w, h, col[1],col[2],col[3])

    -- Draw outline
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", x, y, w, h)
    self:drawInventoryName()
end


function Inventory:drawUI()
    assert(client, "Shouldn't be called serverside")
    if not self:isOpen() then
        return
    end

    love.graphics.push("all")
    -- No need to scale for UI- this should be done by draw system.

    local X,Y,W,H = self:getDrawBounds()

    local col = self.color or WHITE
    
    love.graphics.setLineWidth(2)
    
    self:drawBackground(X,Y,W,H)

    local offset = self.slotSeparation / 2

    -- draw interior
    for x = 0, self.width - 1 do
        for y = 0, self.height - 1 do
            local inv_x, inv_y = x+1, y+1 -- inventory is 1-indexed
            if self:slotExists(inv_x, inv_y) then
                self:drawSlot(inv_x, inv_y, offset, col)
            end
        end
    end

    self:drawForeground(X,Y,W,H)

    do 
        local x,y,w,h = getExitButtonBounds(self)
        self:drawExitButton(x,y,w,h)
    end

    umg.call("items:drawInventory", self.owner, X,Y,W,H)
    
    love.graphics.pop()
end



return Inventory
