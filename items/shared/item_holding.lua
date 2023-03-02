

local holdingItemGroup = umg.group("holdItem", "x", "y")



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


local function getHoldDistance(ent, holder)
    local dis1 = ent.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    local dis2 = holder.itemHoldDistance or DEFAULT_HOLD_DISTANCE
    return dis1 + dis2
end




local itemHoldPositioning = {--[[
    this table contains functions that act on the different hold types
]]}


local TOOL_USE_TIME = 0.3

function itemHoldPositioning.tool(item_ent, holder_ent)
    local dx,dy = getLookDirection(holder_ent)
    local curTime = base.getGameTime()
    local t = math.max(0, ((item_ent.item_lastUseTime or curTime) - curTime) + TOOL_USE_TIME) / TOOL_USE_TIME
    local sinv = math.sin(t*6.282)
    local hold_dist = getHoldDistance(item_ent, holder_ent)

    item_ent.rot = -math.atan2(dx,dy) + math.pi/2 + sinv/3
    item_ent.scaleX = dx>0 and 1 or -1
    -- TODO: This ^^^ is crappy!!! This will overwrite existing scale
    item_ent.x = holder_ent.x + dx * hold_dist
    item_ent.y = holder_ent.y + dy * hold_dist
end



function itemHoldPositioning.spin(item_ent, holder_ent)
    local rot = base.getGameTime() * 7
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
    local t = math.max(0, ((item_ent.item_lastUseTime or curTime) - curTime) + RECOIL_TIME) / RECOIL_TIME
    local sinv = math.sin(t*3.14)
    local recoil_amount = ((1-sinv)/2 + 0.5)
    local hold_dist = getHoldDistance(item_ent, holder_ent)
    hold_dist = hold_dist * recoil_amount

    item_ent.rot = -math.atan2(dx,dy) + math.pi/2 + sinv/3
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





umg.on("gameUpdate", function()
    for _, ent in ipairs(holdingItemGroup) do
        if umg.exists(ent.holdItem) then
            ent.holdItem.hidden = false
            local item_ent = ent.holdItem
            assert(item_ent.itemHoldType, "held items need holdType")
            if not itemHoldPositioning[item_ent.itemHoldType] then 
                error("unknown itemHoldType " .. tostring(item_ent.itemHoldType) .. " for entity " .. tostring(item_ent))
            end
            itemHoldPositioning[item_ent.itemHoldType](item_ent, ent)
        else
            ent.holdItem = nil -- could have been deleted 
        end
    end
end)


