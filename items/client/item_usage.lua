
--[[

Handles moving animation of entities holding items,
item usage,
and item facing direction.



]]


local anim_group = group("x", "y", "image", "holdAnimation", "inventory")



local tick = 0

local DEFAULT_ANIM_SPEED = 2 -- seconds to complete animation loop

local DEFAULT_ANIM_ACTIVATION_SPEED = 5

local ent_to_direction = {
    --[[
        [ent] = current_direction_of_this_ent
    ]]
}

--[[
    directions are as follows:
    `up`, `down`, `left`, `right`
]]




anim_group:on_added(function(ent)
    ent_to_direction[ent] = "down"
end)


anim_group:on_removed(function(ent)
    ent_to_direction[ent] = nil
end)




local distance = math.distance
local abs = math.abs
local min = math.min
local floor = math.floor

local function getSpeedDirection(ent, entspeed)
    local manim = ent.holdAnimation
    if entspeed > manim.activation then
        local dir
        if abs(ent.vx) > abs(ent.vy) then
            -- Left or Right
            if ent.vx < 0 then
                dir = "left"
            else
                dir = "right"
            end
        else
            -- up or down
            if ent.vy < 0 then
                dir = "up"
            else
                dir = "down"
            end
        end
        ent_to_direction[ent] = dir
        return dir
    else
        -- The entity is not going fast enough;
        -- return it's previous direction
        return ent_to_direction[ent]
    end
end




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



client.on("setInventoryHoldValues", function(ent, hold_x, hold_y, dx, dy)
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
    recoil = true
}


local function getTurnDirection(ent)
    local holding_item = ent.inventory:getHoldingItem()
    if holding_item and holding_item.itemHoldType then
        if turnTypes[holding_item.itemHoldType] then
            -- face towards mouse
            return getFaceDirection(ent)
        end
    end
end


local function getDirection(ent, entspeed)
    local dir = getTurnDirection(ent)
    if not dir then
        return getSpeedDirection(ent, entspeed)
    else
        return dir
    end
end




local function updateEnt(ent)
    local manim = ent.holdAnimation
    local entspeed = distance(ent.vx, ent.vy)
    
    local dir = getDirection(ent, entspeed) -- should be up, down, left, or right
    local spd = manim.speed or DEFAULT_ANIM_SPEED

    local anim = ent.holdAnimation[dir]
    -- TODO: Chuck an assertion here to ensure that people aren't misusing
    -- the holdAnimation component. (all directions must be defined)
    local len = #anim

    if entspeed > (manim.activation or DEFAULT_ANIM_ACTIVATION_SPEED) then
        local frame_i = min(len, floor(((tick % spd) / spd) * len) + 1)
        local frame = anim[frame_i]
        ent.image = frame
    else
        ent.image = anim[1]
    end
end


on("update", function(dt)
    tick = tick + dt
    for i=1, #anim_group do
        local ent = anim_group[i]
        updateEnt(ent)
    end
end)





--[[

rendering of the actual tool:

]]



local control_inventory_ents = group("controllable", "controller", "inventory", "x", "y")


on("tick", function(dt)
    -- TODO: Do delta compression for this.
    for i=1, #control_inventory_ents do
        local ent = control_inventory_ents[i]
        if ent.controller == username then
            local inv = ent.inventory
            local hold_x, hold_y = inv.holding_x, inv.holding_y
            client.send("setInventoryHoldValues", ent, hold_x, hold_y, getPointDirection(ent))
        end
    end
end)



local function renderHolder(ent, holder, rot, dist, sx, sy)
    local img = ent.itemHoldImage or ent.image
    if not assets.images[img] then
        error("Unknown image:  " .. tostring(img))
    end
    local dx, dy = getPointDirection(holder)
    local quad = assets.images[img]
    local ox, oy = base.getQuadOffsets(quad)

    graphics.atlas:draw(
        quad, 
        holder.x + dx*dist, 
        holder.y + dy*dist,
        rot,
        sx or 1,sy or 1,
        ox, oy
    )
end

local holdRendering = {}

function holdRendering.tool(ent, holder)

end

function holdRendering.spin(ent, holder)

end


local SWING_HOLD_DISTANCE = 15
function holdRendering.swing(ent, holder)
    local dx,dy = getPointDirection(holder)
    local rot = -math.atan2(dx,dy) + math.pi/2
    local sign = dx>0 and 1 or -1
    renderHolder(ent, holder, rot, SWING_HOLD_DISTANCE, 1, sign)
end

function holdRendering.recoil(ent)

end

function holdRendering.above(ent)

end

function holdRendering.place(ent)

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

