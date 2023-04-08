
--[[

Handles ents that are being controlled by the player.

Currently there are no restrictions for moving your own entity;
this means that modified clients can teleport anywhere on the screen

]]


local constants = require("shared.constants")

local State = require("shared.state.state")


local controlAdmin = {}

function controlAdmin.forceSetPlayerPosition(ent, x, y, z)
    ent.x = x
    ent.y = y
    ent.z = z or ent.z
    -- we gotta force a sync here, since clients ignore position syncs from
    -- the server.
    local sender = ent.controller
    server.unicast(sender, "forceSetPlayerPosition", ent, x, y, z)
end



local function filterPlayerPosition(sender, ent, x,y,z)
    if not umg.exists(ent) then
        return false -- DENY! Non existant entity
    end
    z = z or 0
    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
        return false -- bad type for x,y, or z
    end
    if State.getCurrentState() ~= "game" then
        return false -- game is probably paused
        -- TODO: This is kinda hacky and shitty
    end

    local basics = ent.controllable and sender == ent.controller and ent.x and ent.y
    if not basics then
        return false
    end

    local dist = math.distance(ent.x-x, ent.y-y, (ent.z or 0)-z)
    local sync_threshold = ent.speed * (1 + constants.PLAYER_MOVE_LEIGHWAY)
    if dist > sync_threshold then
        -- TODO: This forceSync call is bad, ddos opportunity here.
        -- Perhaps we should instead mark this entity as "should force sync"
        -- and then sync once on the next tick?
        -- with this setup, hacked clients could send multiple position packets per frame and ddos the server
        controlAdmin.forceSetPlayerPosition(ent, ent.x, ent.y, ent.z)
        return false -- ent moving too fast!
    end

    return true
end



local function filterPlayerVelocity(sender_username, ent, vx,vy,vz)
    if not umg.exists(ent) then
        return false -- DENY! Non existant entity
    end
    if type(vx) ~= "number" or type(vy) ~= "number" or (vz and (type(vz) ~= "number")) then
        return false
    end
    if State.getCurrentState() ~= "game" then
        return false -- game is probably paused
        -- TODO: This is kinda hacky and shitty
    end

    return ent.controllable and sender_username == ent.controller
        and ent.vx and ent.vy
end



server.on("setPlayerPosition", function(sender_username, ent, x,y,z)
    if not filterPlayerPosition(sender_username, ent, x,y,z)then
        return
    end

    ent.x = x
    ent.y = y
    ent.z = z or ent.z
end)





server.on("setPlayerVelocity", function(sender_username, ent, vx,vy,vz)
    if not filterPlayerVelocity(sender_username, ent, vx,vy,vz) then
        return
    end
    local max_spd = (ent.speed or constants.DEFAULT_SPEED) 
    if max_spd >= vx and max_spd >= vy then
        -- check that the player aint cheating.
        -- Note that the player can cheat by "flying" though, haha.
        -- (Because vz isn't checked)
        ent.vx = vx
        ent.vy = vy
        if ent.vz then
            ent.vz = vz
        end
    end
end)


return controlAdmin
