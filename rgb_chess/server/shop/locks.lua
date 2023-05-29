
local Board 
umg.on("@load", function()
    Board = require("server.board")
end)


local comps = {
    "isLocked", "x", "y", "image"
}

local function syncComponents(lockEnt)
    for _, cmp in ipairs(comps) do
        sync.syncComponent(lockEnt, cmp)
    end
end




local function lock(lockEnt)
    local board = Board.getBoard(lockEnt.rgbTeam)
    local x, y = board:getCardXY(lockEnt.shopIndex)
    lockEnt.x, lockEnt.y = x, y
    lockEnt.isLocked = true
    lockEnt.image = lockEnt.LOCKED_IMG
    syncComponents(lockEnt)
    umg.call("lockCard", lockEnt)
end


local function unlock(lockEnt)
    local board = Board.getBoard(lockEnt.rgbTeam)
    local x, y = board:getCardXY(lockEnt.shopIndex)
    lockEnt.x, lockEnt.y = x, y + constants.CARD_LOCK_Y_SPACING
    lockEnt.isLocked = false
    lockEnt.image = lockEnt.UNLOCKED_IMG
    syncComponents(lockEnt)
    umg.call("unlockCard", lockEnt)
end



local function toggle(lockEnt)
    if lockEnt.isLocked then
        unlock(lockEnt)
    else
        lock(lockEnt)
    end
end



umg.on("entityClicked", function(ent, username, button, worldX, worldY)
    if not ent.rgbCardLock then
        return
    end
    if not ent.rgbTeam == username then
        return
    end

    toggle(ent)
end)

