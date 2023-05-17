
local constants = require("shared.constants")


local openGroup = umg.group("openable", "inventory", "x", "y")

local controllableGroup = umg.group("controllable", "inventory")


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



local DEFAULT_OPEN_SOUND = "chestOpenSound"
local DEFAULT_CLOSE_SOUND = "chestCloseSound"

local function close(inv)
    local opn = inv.owner.openable
    local sound = opn.closeSound or DEFAULT_CLOSE_SOUND
    base.client.playSound(sound, 1, 0.7, nil, 0, 0.3)
    inv:close()
    openInventories.close(inv)
end


local function open(inv)
    local opn = inv.owner.openable
    local sound = opn.openSound or DEFAULT_OPEN_SOUND
    base.client.playSound(sound, 1, 1.4, nil, 0, 0.3)
    if openInv then
        close(openInv)
    end
    inv:open()
    openInventories.open(inv)
end


local function tryOpenInv(player, inv_ent)
    local opn = inv_ent.openable
    local inv = inv_ent.inventory
    if inv:canBeOpenedBy(player) then
        if player.inventory and player.inventory:canBeOpenedBy(player) then
            player.inventory:open()
        end
        open(inv)
    else
        local sound = opn.closeSound or DEFAULT_CLOSE_SOUND
        base.client.playSound(sound, 1, 0.7, nil, 0, 0.15)
    end
end



local function pollForClosure(openInventory)

end



umg.on("gameUpdate", function(dt)
    if openInv then
        local player = base.getPlayer()
        if math.distance(player, openInv.owner) > (constants.DEFAULT_OPENABLE_DISTANCE + 1) then
            local ent = openInv.owner
            local sound = ent.openable.closeSound or DEFAULT_CLOSE_SOUND
            openInv:close()
            if player.inventory then
                player.inventory:close()
            end
            base.client.playSound(sound, 1, 0.7, nil, 0, 0.15)    
            openInv = nil
        end
    end
end)



local listener = base.client.input.Listener({priority = 2})


function listener:mousepressed(mx, my, button)
    if button == OPEN_BUTTON then
        local player = base.getPlayer()
        if (not openInv) or (not openInv:withinBounds(mx,my)) then
            if player then
                local inv_ent = searchForOpenable(player, mx, my)
                if inv_ent then
                    tryOpenInv(player, inv_ent)
                end
            end
        end
    end
end


local function pressButton(player)
    if player.inventory and player.openable then
        if player.inventory.isOpen then
            if openInv then
                close(openInv)
            end
            player.inventory:close()
        else
            player.inventory:open()
        end
    end
end


function listener:keypressed(key, scancode, isrepeat)
    local inputEnum = self:getInputEnum(scancode)
    -- TODO: Allow for controls to be set
    if inputEnum == base.client.input.BUTTON_2 then
        for _, player in ipairs(controllableGroup)do
            if isInControlOf(player) then
                pressButton(player)
            end
        end
        self:lockKey(scancode)
    end
end


