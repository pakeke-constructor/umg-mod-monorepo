
local constants = require("shared.constants")


local openGroup = umg.group("openable", "inventory", "x", "y")

local controlInventoryGroup = umg.group("controllable", "inventory")

local openInventories = require("client.open_inventories")



local OPEN_BUTTON = 2

local MOUSE_INTERACTION_DIST = 30



local function searchForOpenable(player, mouse_x, mouse_y)
    local best_dist = math.huge
    local best_inv_ent = nil
    local x, y = rendering.toWorldCoords(mouse_x, mouse_y)
    for _, ent in ipairs(openGroup) do
        -- TODO: IMPORTANT: spatial partition this.
        local dist = math.distance(ent, player)
        local mouse_dist = math.distance(ent.x-x,ent.y-y)
        local inv = ent.inventory
        if inv:canBeOpenedBy(player) and dist < best_dist and mouse_dist <= MOUSE_INTERACTION_DIST then
            best_inv_ent = ent
            best_dist = dist
        end
    end
    return best_inv_ent
end



local function isInControlOf(player)
    return player.controller == client.getUsername()
end





local function open(inv)
    local opn = inv.owner.openable
    if opn.openSound then
        base.client.sound.playSound(opn.openSound, 1, 1.4, nil, 0, 0.3)
    end
    inv:open()
end


local function tryOpenInv(player, inv_ent)
    local opn = inv_ent.openable
    local inv = inv_ent.inventory
    if inv:canBeOpenedBy(player) then
        player.inventory:open()
        open(inv)
    else
        if opn.closeSound then
            -- locked!
            base.client.sound.playSound(opn.closeSound, 1, 0.7, nil, 0, 0.15)
        end
    end
end





local listener = input.Listener({priority = 2})


function listener:mousepressed(mx, my, button)
    if button == OPEN_BUTTON then
        -- Try open inventories
        for _, player in ipairs(controlInventoryGroup)do
            if isInControlOf(player) then
                local inv_ent = searchForOpenable(player, mx, my)
                if inv_ent then
                    tryOpenInv(player, inv_ent)
                end
            end
        end
    end
end




local function areMostInventoriesOpen()
    --[[
        The client may be controlling multiple players at once.
        This function checks if the majority of players have open inventories.
    ]]
    local ct = 0
    local tot_ct = 0
    for _, player in ipairs(controlInventoryGroup)do
        if isInControlOf(player) then
            local inv = player.inventory
            tot_ct = tot_ct + 1
            if inv:isOpen() then
                ct = ct + 1
            end
        end
    end

    if tot_ct > 0 then
        return (ct / tot_ct) > 0.5
    end
    return false
end


local function openAllPlayerInventories()
    for _, player in ipairs(controlInventoryGroup)do
        if isInControlOf(player) then
            local inv = player.inventory
            inv:open()
        end
    end
end


local function closeAllInventories()
    local buffer = objects.Array()
    -- gotta buffer it, since we are removing during iter
    for _, inv in ipairs(openInventories.getOpenInventories())do
        buffer:add(inv)
    end
    for _, inv in ipairs(buffer)do
        inv:close()
    end
end



function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    -- TODO: Allow for controls to be set
    if inputEnum == input.BUTTON_2 then
        if areMostInventoriesOpen() then
            -- most player inventories are open, close all inventories
            closeAllInventories()
        else
            openAllPlayerInventories()
        end
        self:lockKey(scancode)
    end
end


