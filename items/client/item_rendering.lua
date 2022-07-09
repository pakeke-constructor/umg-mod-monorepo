
--[[

Handles moving animation of entities holding items,
item usage,
and item facing direction.



]]




local function normalize(x,y)
    local mag = math.sqrt(x*x + y*y)
    if mag > 0 then 
        return x/mag, y/mag
    else
        return 0,0
    end
end


local function getMouseDirection(ent)
    --[[
        returns the normalized vector from entity towards mouse.
    ]]
    local mx, my = base.camera:getMousePosition()
    local dx, dy = mx - ent.x, my - ent.y
    return normalize(dx, dy)
end



local holding_ents = group("inventory", "x", "y")

local ent_to_pointDirectionX = {
    -- holding entity to point direction
}
local ent_to_pointDirectionY = {
    -- holding entity to point direction
}

holding_ents:on_removed(function(ent)
    ent_to_pointDirectionX[ent] = nil
    ent_to_pointDirectionY[ent] = nil
end)



client.on("setInventoryHoldValues", function(ent, faceDir, hold_x, hold_y, dx, dy)
    if ent.controller == username then
        -- Ignore broadcasts for our own entities;
        -- We will have more up to date data.
        return 
    end
    local inv = ent.inventory
    inv.holding_x = hold_x
    inv.holding_y = hold_y
    ent_to_pointDirectionX[ent] = dx
    ent_to_pointDirectionY[ent] = dy
    ent.faceDirection = faceDir
end)




local function getPointDirection(ent)
    if ent.controller == username then
        return normalize(getMouseDirection(ent))
    else
        local x,y = ent_to_pointDirectionX[ent], ent_to_pointDirectionY[ent]
        if x and y then
            return x,y
        end
        return 0,0
    end
end




local function getFaceDirection(ent)
    local dx, dy = getPointDirection(ent)
    if math.abs(dx) > math.abs(dy) then
        -- facing left or right
        if dx > 0 then
            return "right"
        else
            return "left"
        end
    else
        -- facing up or down
        if dy > 0 then
            return "down"
        else
            return "up"
        end
    end
end



--[[
    hold types where entities should face towards the mouse.
]]
local turnTypes = {
    tool = true, 
    spin = true,
    swing = true,
    recoil = true,
    place = true,
    custom = true
}


local function getTurnDirection(ent)
    local holding_item = ent.inventory:getHoldingItem()
    if holding_item and holding_item.itemHoldType then
        if turnTypes[holding_item.itemHoldType] then
            -- face towards mouse
            return getFaceDirection(ent)
        end
    end
    return nil -- else return nil; this means that `ent` will face in the
    -- direction of movement.
end


local control_turn_ents = group(
    "faceDirection", "inventory", "controllable", "controller", "x", "y"
)


on("update", function(dt)
    for i=1, #control_turn_ents do
        local ent = control_turn_ents[i]
        if ent.controller == username then
            ent.faceDirection = getTurnDirection(ent)
        end
    end
end)



local control_inventory_ents = group("controllable", "controller", "inventory", "x", "y")

on("tick", function(dt)
    for i=1, #control_inventory_ents do
        local ent = control_inventory_ents[i]
        if ent.controller == username then
            local inv = ent.inventory
            local hold_x, hold_y = inv.holding_x, inv.holding_y
            client.send("setInventoryHoldValues", ent, ent.faceDirection, hold_x, hold_y, getPointDirection(ent))
        end
    end
end)




























--[[

===============================
rendering of held items.
===============================

]]

local time = timer.getTime()

local function onUseItem(item, holder_ent, ...)
    item.item_lastUseTime = time
end

on("update", function(dt)
    time = timer.getTime()
end)



local function renderHolder(ent, holder, rot, dist, sx, sy, oxx, oyy)
    oxx = oxx or 0
    oyy = oyy or 0
    local img = ent.itemHoldImage or ent.image
    if not assets.images[img] then
        error("Unknown image for holding item:  " .. tostring(img))
    end
    local dx, dy = getPointDirection(holder)
    local quad = assets.images[img]
    local ox, oy = base.getQuadOffsets(quad)

    graphics.atlas:draw(
        quad, 
        holder.x + dx*dist + oxx, 
        holder.y + dy*dist + oyy,
        rot,
        sx or 1,sy or 1,
        ox, oy
    )
end

local holdRendering = {}


local TOOL_HOLD_DISTANCE = 20

local TOOL_USE_TIME = 0.3
function holdRendering.tool(ent, holder)
    local dx,dy = getPointDirection(holder)
    local t = math.max(0, ((ent.item_lastUseTime or time) - time) + TOOL_USE_TIME) / TOOL_USE_TIME
    local sinv = math.sin(t*6.282)
    local rot = -math.atan2(dx,dy) + math.pi/2 + sinv/3
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, TOOL_HOLD_DISTANCE + sinv * TOOL_HOLD_DISTANCE/3, 1, sign)
end



function holdRendering.spin(ent, holder)
    local rot = timer.getTime() * 7
    local dx,dy = getPointDirection(holder)
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, TOOL_HOLD_DISTANCE, 1, sign)
end


local SWING_TIME = 0.3
function holdRendering.swing(ent, holder)
    error("nyi")
end


local RECOIL_TIME = 0.3
function holdRendering.recoil(ent, holder)
    local dx,dy = getPointDirection(holder)
    local t = math.max(0, ((ent.item_lastUseTime or time) - time) + RECOIL_TIME) / RECOIL_TIME
    local sinv = math.sin(t*3.14)
    local rot = -math.atan2(dx,dy) + math.pi/2
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, TOOL_HOLD_DISTANCE - sinv * TOOL_HOLD_DISTANCE/3, 1, sign)
end


function holdRendering.above(ent, holder)
    local _,oy = base.getQuadOffsets(ent.image)
    renderHolder(ent, holder, 0, 0, 1, 1, 0, -oy*2)
end

function holdRendering.place(item, holder)
    local img = item.itemHoldImage or item.image
    if img then
        graphics.push("all")
        graphics.setLineWidth(6)
        
        local x, y = base.camera:getMousePosition()
        local modX, modY = 1,1
        if item.placeGridSizeX or item.placeGridSizeY or item.placeGridSize then
            if item.placeGridSizeX then
                assert(type(item.placeGridSizeX) == "number")
                assert(type(item.placeGridSizeY) == "number")
                modX = item.placeGridSizeX or 1
                modY = item.placeGridSizeY or 1
            else
                assert(type(item.placeGridSize) == "number")
                modX = item.placeGridSize
                modY = item.placeGridSize
            end
        end
        x = math.floor((x / modX) + 1/2) * modX
        y = math.floor((y / modY) + 1/2) * modY

        if item:canUse(x, y) then
            graphics.setColor(1,1,1,0.4)
        else
            graphics.setColor(1,0,0,0.4)
        end

        graphics.line(x,y, holder.x,holder.y)
        local quad = assets.images[img]
        local ox, oy = base.getQuadOffsets(quad)
        graphics.atlas:draw(
            quad, x, y, 0, 1, 1, ox, oy
        )
        graphics.pop()
    end
end


function holdRendering.custom(item, holder)
    assert(item.customHoldDraw, "when itemHoldType is 'custom', item.customHoldDraw must be set.")
    item:customHoldDraw(holder)
end


on("drawEntity", function(ent)
    if ent.inventory then
        local h = ent.inventory:getHoldingItem()
        if h and h.itemHoldType then
            if not holdRendering[h.itemHoldType] then
                error("Item entity had invalid itemHoldType value: " .. tostring(h.itemHoldType))
            end
            holdRendering[h.itemHoldType](h, ent)
        end
    end
end)




return {
    onUseItem = onUseItem
}

