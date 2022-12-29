
--[[

Handles world position of held items.

I.e. stuff like rotation, distance from parent entity, etc.

lookX and lookY components are also used here.


]]

local itemHolding = {}



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



local function getLookDirection(ent)
    if ent.lookX and ent.lookY then
        return ent.lookX - ent.x, ent.lookY - ent.y
    elseif ent.controller == client.getUsername() then
        return normalize(getMouseDirection(ent))
    else
        if ent.vx and ent.vy and math.distance(ent.vx,ent.vy) > 0 then
            local dst = math.distance(ent.vx, ent.vy)
            return ent.vx / dst, ent.vy / dst
        end
        return 0,0
    end
end






client.on("setInventoryHoldItem", function(ent, item)
    if ent.controller == client.getUsername() then
        -- Ignore broadcasts for our own entities;
        -- We will have more up to date data.
        return 
    end

    ent.holdItem = item
end)



-- ORIGINALLY:::   setInventoryHoldDirection
client.on("setItemHoldValue", function(ent, itemEnt, lookX, lookY)
    ent.lookX = lookX
    ent.lookY = lookY
    ent.holdItem = itemEnt
    itemEnt.x = lookX
    itemEnt.y = lookY
end)




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


local control_turn_ents = umg.group(
    "faceDirection", "inventory", "controllable", "controller", "x", "y"
)


umg.on("gameUpdate", function(dt)
    for i=1, #control_turn_ents do
        local ent = control_turn_ents[i]
        if ent.controller == client.getUsername() then
            ent.faceDirection = getTurnDirection(ent)
        end
    end
end)



local controlInventoryGroup = umg.group("controllable", "controller", "inventory", "x", "y")

umg.on("tick", function(dt)
    for i, ent in ipairs(controlInventoryGroup) do
        if ent.controller == client.getUsername() then
            local inv = ent.inventory
            if inv then
                local hold_x, hold_y = inv.holding_x, inv.holding_y
                if hold_x and hold_y and inv:get(hold_x, hold_y) then
                    local hold_item = inv:get(hold_x, hold_y)
                    client.send("setInventoryHoldItemPosition", ent, ent.faceDirection, hold_x, hold_y, getLookDirection(ent))
                end
            end
        end
    end
end)






function itemHolding.onUseItem(item, holder_ent, ...)
    item.item_lastUseTime = base.getGameTime()
end




local function setHoldPosition(ent, holder, rot, dist, sx, sy, oxx, oyy)
    oxx = oxx or 0
    oyy = oyy or 0
    local img = ent.itemHoldImage or ent.image
    if not client.assets.images[img] then
        error("Unknown image for holding item:  " .. tostring(img))
    end
    local dx, dy = getLookDirection(holder)
    local quad = client.assets.images[img]
    local ox, oy = base.getQuadOffsets(quad)

        quad, 
        holder.x + dx*dist + oxx, 
        holder.y - (holder.z or 0)/2 + dy*dist + oyy,
        rot,
        sx or 1,sy or 1,
        ox, oy
    )
end



local itemHoldPositioning = {
--[[
    this table contains functions that return the position,
    scaleX, scaleY, and rotation of a hold item, given a look direction.
]]
}


local TOOL_HOLD_DISTANCE = 20

local TOOL_USE_TIME = 0.3
function itemHoldPositioning.tool(ent, holder)
    local dx,dy = getLookDirection(holder)
    local curTime = base.getGameTime()
    local t = math.max(0, ((ent.item_lastUseTime or curTime) - curTime) + TOOL_USE_TIME) / TOOL_USE_TIME
    local sinv = math.sin(t*6.282)
    local rot = -math.atan2(dx,dy) + math.pi/2 + sinv/3
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, TOOL_HOLD_DISTANCE + sinv * TOOL_HOLD_DISTANCE/3, 1, sign)
end



function itemHoldPositioning.spin(ent, holder)
    local rot = base.getGameTime() * 7
    local dx,dy = getLookDirection(holder)
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, TOOL_HOLD_DISTANCE, 1, sign)
end


local SWING_TIME = 0.3

function itemHoldPositioning.swing(ent, holder)
    error("nyi")
end


local RECOIL_TIME = 0.3
function itemHoldPositioning.recoil(ent, holder)
    local dx,dy = getLookDirection(holder)
    local curTime = base.getGameTime()
    local t = math.max(0, ((ent.item_lastUseTime or curTime) - curTime) + RECOIL_TIME) / RECOIL_TIME
    local sinv = math.sin(t*3.14)
    local rot = -math.atan2(dx,dy) + math.pi/2
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, TOOL_HOLD_DISTANCE - sinv * TOOL_HOLD_DISTANCE/3, 1, sign)
end



function itemHoldPositioning.above(ent, holder)
    local _,oy = base.getQuadOffsets(ent.image)
    renderHolder(ent, holder, 0, 0, 1, 1, 0, -oy*2)
end


function itemHoldPositioning.place(item, holder)
    local img = item.itemHoldImage or item.image
    if img then
        love.graphics.push("all")
        love.graphics.setLineWidth(6)
        
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
            love.graphics.setColor(1,1,1,0.4)
        else
            love.graphics.setColor(1,0,0,0.4)
        end

        love.graphics.line(x,y, holder.x,holder.y)
        local quad = client.assets.images[img]
        local ox, oy = base.getQuadOffsets(quad)
        client.atlas:draw(
            quad, x, y, 0, 1, 1, ox, oy
        )
        love.graphics.pop()
    end
end


function itemHoldPositioning.custom(item, holder)
    error("nyi")
    assert(item.customHoldDraw, "when itemHoldType is 'custom', item.customHoldDraw must be set.")
    item:customHoldDraw(holder)
end

