





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




local holdTypes = {--[[
    this table contains functions that act on the different hold types
]]}


local TOOL_USE_TIME = 0.3

function holdTypes.tool(itemEnt, holderEnt)
    local dx,dy = getLookDirection(holderEnt)
    local curTime = state.getGameTime()
    local t = math.max(0, ((itemEnt.itemLastUseTime or curTime) - curTime) + TOOL_USE_TIME) / TOOL_USE_TIME
    local sinv = math.sin(t*6.282)
    local hold_dist = getHoldDistance(itemEnt, holderEnt)

    itemEnt.rot = -math.atan2(dx,dy) + math.pi/2 + sinv/3
    itemEnt.scaleX = dx>0 and 1 or -1
    -- TODO: This ^^^ is crappy!!! This will overwrite existing scale
    itemEnt.x = holderEnt.x + dx * hold_dist
    itemEnt.y = holderEnt.y + dy * hold_dist
end



local SWING_TIME = 0.3

--[[

TODO: Implement swing item hold type here!


function holdTypes.swing(ent, holder)
    error("nyi")
end

]]




local RECOIL_TIME = 0.3

function holdTypes.recoil(itemEnt, holderEnt)
    local dx,dy = getLookDirection(holderEnt)
    local curTime = state.getGameTime()
    local t = math.max(0, ((itemEnt.itemLastUseTime or curTime) - curTime) + RECOIL_TIME) / RECOIL_TIME
    local sinv = math.sin(t*3.14)
    local recoil_amount = ((1-sinv)/2 + 0.5)
    local hold_dist = getHoldDistance(itemEnt, holderEnt)
    hold_dist = hold_dist * recoil_amount

    local addRot = itemEnt.itemHoldRotation or 0
    itemEnt.rot = addRot + -math.atan2(dx,dy) + math.pi/2 + sinv/3
    itemEnt.scaleY = dx>0 and 1 or -1
    itemEnt.x = holderEnt.x + dx * hold_dist
    itemEnt.y = holderEnt.y + dy * hold_dist
end



function holdTypes.above(itemEnt, holderEnt)
    local hold_dist = getHoldDistance(itemEnt, holderEnt)
    itemEnt.x = holderEnt.x
    itemEnt.y = holderEnt.y - hold_dist
end





umg.answer("usables:getItemholdPositioning", function(itemEnt, holderEnt, i, len)
    if itemEnt.itemHoldType then
        local holdType = itemEnt.itemHoldType
        if not holdTypes[holdType] then
            error("Unknown item hold type: " .. tostring(holdType))
        end

        local func = holdTypes[holdType]
        func(itemEnt, holderEnt, i, len)
    end
end)

