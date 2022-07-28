
local openGroup = group("openable", "inventory", "x", "y")



local OPEN_BUTTON = 2

local DEFAULT_OPENABLE_DISTANCE = 100

local MOUSE_INTERACTION_DIST = 30


local function searchForOpenable(player, mx, my)
    local best_dist = math.huge
    local best_inv_ent = nil
    local x, y = base.camera:toWorldCoords(mx, my)
    for _, inv in ipairs(openGroup) do
        -- todo; spatial partition this.
        local dist = math.distance(inv, player)
        local mouse_dist = math.distance(inv.x-x,inv.y-y)
        if dist < best_dist and mouse_dist <= MOUSE_INTERACTION_DIST then
            if dist <= (inv.openable.distance or DEFAULT_OPENABLE_DISTANCE) then
                best_inv_ent = inv
                best_dist = dist
            end
        end
    end
    return best_inv_ent
end




local openInv = nil

local DEFAULT_OPEN_SOUND = "chestOpenSound"
local DEFAULT_CLOSE_SOUND = "chestCloseSound"

local function close(inv)
    local opn = inv.owner.openable
    local sound = opn.closeSound or DEFAULT_CLOSE_SOUND
    base.playSound(sound, 1, 0.7, nil, 0, 0.3)
    inv:close()
    openInv = nil
end


local function open(inv)
    local opn = inv.owner.openable
    local sound = opn.openSound or DEFAULT_OPEN_SOUND
    base.playSound(sound, 1, 1.4, nil, 0, 0.3)
    if openInv then
        close(openInv)
    end
    inv:open()
    openInv = inv
end


local function tryOpenInv(player, inv_ent)
    local opn = inv_ent.openable
    local inv = inv_ent.inventory
    if inv:canOpen(player) then
        if player.inventory and player.inventory:canOpen(player) then
            player.inventory:open()
        end
        open(inv)
    else
        local sound = opn.closeSound or DEFAULT_CLOSE_SOUND
        base.playSound(sound, 1, 0.7, nil, 0, 0.15)
    end
end


on("update", function(dt)
    if openInv then
        local player = base.getPlayer()
        if math.distance(player, openInv.owner) > (DEFAULT_OPENABLE_DISTANCE + 1) then
            local ent = openInv.owner
            local sound = ent.openable.closeSound or DEFAULT_CLOSE_SOUND
            openInv:close()
            if player.inventory then
                player.inventory:close()
            end
            base.playSound(sound, 1, 0.7, nil, 0, 0.15)    
            openInv = nil
        end
    end
end)



on("mousepressed", function(mx, my, button)
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
end)



local INVENTORY_TOGGLE_BUTTON = "f"

on("keypressed", function(key, scancode)
    if scancode == INVENTORY_TOGGLE_BUTTON then
        local player = base.getPlayer()
        if player.inventory then
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
end)


