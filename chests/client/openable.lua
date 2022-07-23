
local openGroup = group("openable", "inventory", "x", "y")



local OPEN_BUTTON = 2

local DEFAULT_OPENABLE_DISTANCE = 100

local MOUSE_INTERACTION_DIST = 40


local function searchForOpenable(player, mx, my)
    local best_dist = math.huge
    local best_inv = nil
    local x, y = base.camera:toWorldCoords(mx, my)
    for _, inv in ipairs(openGroup) do
        -- todo; spatial partition this.
        local dist = math.distance(inv, player)
        local mouse_dist = math.distance(inv.x-x,inv.y-y)
        if dist < best_dist and mouse_dist <= MOUSE_INTERACTION_DIST then
            if dist <= (inv.openable.distance or DEFAULT_OPENABLE_DISTANCE) then
                best_inv = inv
                best_dist = dist
            end
        end
    end
    return best_inv
end


on("mousepressed", function(mx, my, button)
    if button == OPEN_BUTTON then
        local player = base.getPlayer()
        if player then
            local inv = searchForOpenable(player, mx, my)
            if inv then
                
            end
        end
    end
end)


