

local holdingItemGroup = umg.group("inventory", "x", "y")



local function getLookDirection(ent)
    if ent.lookX and ent.lookY then
        return math.normalize(ent.lookX - ent.x, ent.lookY - ent.y)
    else
        if ent.vx and ent.vy then
            return math.normalize(ent.vx, ent.vy)
        end
    end
    return 0,0
end



local DEFAULT_HOLD_DISTANCE = 10


local function getHoldDistance(ent, holderEnt)
    local dis1 = ent.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    local dis2 = holderEnt.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    return dis1 + dis2
end




local itemHoldPositioning = {--[[
    this table contains functions that act on the different hold types
]]}


local TOOL_USE_TIME = 0.3

function itemHoldPositioning.tool(item_ent, holder_ent)
    local dx,dy = getLookDirection(holder_ent)
    local curTime = base.getGameTime()
    local t = math.max(0, ((item_ent.itemLastUseTime or curTime) - curTime) + TOOL_USE_TIME) / TOOL_USE_TIME
    local sinv = math.sin(t*6.282)
    local hold_dist = getHoldDistance(item_ent, holder_ent)

    item_ent.rot = -math.atan2(dx,dy) + math.pi/2 + sinv/3
    item_ent.scaleX = dx>0 and 1 or -1
    -- TODO: This ^^^ is crappy!!! This will overwrite existing scale
    item_ent.x = holder_ent.x + dx * hold_dist
    item_ent.y = holder_ent.y + dy * hold_dist
end



function itemHoldPositioning.spin(item_ent, holder_ent)
    local rot = base.getGameTime() * 7 -- todo: allow for changing of rot speed
    local dx,dy = getLookDirection(holder_ent)
    local hold_dist = getHoldDistance(item_ent, holder_ent)

    item_ent.rot = rot
    item_ent.x = holder_ent.x + dx * hold_dist
    item_ent.y = holder_ent.y + dy * hold_dist
end



local SWING_TIME = 0.3

function itemHoldPositioning.swing(ent, holder)
    error("nyi")
end




local RECOIL_TIME = 0.3

function itemHoldPositioning.recoil(item_ent, holder_ent)
    local dx,dy = getLookDirection(holder_ent)
    local curTime = base.getGameTime()
    local t = math.max(0, ((item_ent.itemLastUseTime or curTime) - curTime) + RECOIL_TIME) / RECOIL_TIME
    local sinv = math.sin(t*3.14)
    local recoil_amount = ((1-sinv)/2 + 0.5)
    local hold_dist = getHoldDistance(item_ent, holder_ent)
    hold_dist = hold_dist * recoil_amount

    local addRot = item_ent.itemHoldRotation or 0
    item_ent.rot = addRot + -math.atan2(dx,dy) + math.pi/2 + sinv/3
    item_ent.scaleY = dx>0 and 1 or -1
    item_ent.x = holder_ent.x + dx * hold_dist
    item_ent.y = holder_ent.y + dy * hold_dist
end


function itemHoldPositioning.above(item_ent, holder_ent)
    local hold_dist = getHoldDistance(item_ent, holder_ent)
    item_ent.x = holder_ent.x
    item_ent.y = holder_ent.y - hold_dist
end



function itemHoldPositioning.custom(item, holder)
    assert(item.itemHoldUpdate, "must be set.")
    item:itemHoldUpdate(holder)
end



local function holdable(item_ent)
    -- items are holdable if they have an itemHoldType
    return item_ent.itemHoldType
end



local function updateHoldItem(ent, item_ent)
    assert(item_ent.itemHoldType, "held items need holdType")
    if not itemHoldPositioning[item_ent.itemHoldType] then 
        error("unknown itemHoldType " .. tostring(item_ent.itemHoldType) .. " for entity " .. tostring(item_ent))
    end
    itemHoldPositioning[item_ent.itemHoldType](item_ent, ent)   
end


local function getHoldItem(ent)
    return ent.inventory and ent.inventory:getHoldItem()
end


umg.on("gameUpdate", function()
    for _, ent in ipairs(holdingItemGroup) do
        local item_ent = getHoldItem(ent)
        if item_ent and holdable(item_ent) then
            updateHoldItem(ent, item_ent)
        end
    end
end)


