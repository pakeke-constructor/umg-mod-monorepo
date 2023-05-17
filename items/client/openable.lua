
local constants = require("shared.constants")


local openGroup = umg.group("openable", "inventory", "x", "y")

local controlInventoryGroup = umg.group("controllable", "inventory")

local openInventories = require("client.open_inventories")



local OPEN_BUTTON = 2

local MOUSE_INTERACTION_DIST = 30



local function searchForOpenable(player, mouse_x, mouse_y)
    local best_dist = math.huge
    local best_inv_ent = nil
    local x, y = base.client.camera:toWorldCoords(mouse_x, mouse_y)
    for _, ent in ipairs(openGroup) do
        -- todo; spatial partition this.
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
        base.client.playSound(opn.openSound, 1, 1.4, nil, 0, 0.3)
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
            base.client.playSound(opn.closeSound, 1, 0.7, nil, 0, 0.15)
        end
    end
end





local listener = base.client.input.Listener({priority = 2})


function listener:mousepressed(mx, my, button)
    if button == OPEN_BUTTON then
        -- Try open inventories
        for _, player in ipairs(controlInventoryGroup)do
            local inv_ent = searchForOpenable(player, mx, my)
            if inv_ent then
                tryOpenInv(player, inv_ent)
            end
        end
    end
end


local function pressButton(player)
    if player.inventory and player.openable then
        if player.inventory.isOpen then
            player.inventory:close()
        else
            player.inventory:open()
        end
    end
end



local function areInventoriesOpen()
    --[[
        The client may be controlling multiple players at once.
        This function checks if the majority of players have open inventories.
    ]]
    local ct = 0
    local tot_ct = 0
    for _, player in ipairs(controlInventoryGroup)do
        local inv = player.inventory
        tot_ct = tot_ct + 1
        if inv:isOpen() then
            ct = ct + 1
        end
    end

    if tot_ct > 0 then
        return (ct / tot_ct) > 0.5
    end
    return false
end


function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    -- TODO: Allow for controls to be set
    if inputEnum == base.client.input.BUTTON_2 then
        for _, player in ipairs(controlInventoryGroup)do
            if isInControlOf(player) then
                pressButton(player)
            end
        end
        self:lockKey(scancode)
    end
end


