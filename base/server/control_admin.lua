
--[[

Handles ents that are being controlled by the player.

Currently there are no restrictions for moving your own entity;
this means that modified clients can teleport anywhere on the screen

]]


local constants = require("shared.constants")

local State = require("shared.state.state")



--[[
We need to make it so server has ultimate authority over player positions;
or else the server won't be able to do anything fancy, like teleports.
]]

local playerGroup = umg.group("controllable", "controller", "x", "y", "vx", "vy")

local playerToLastX = {} -- [player] -> last seen X position
local playerToLastY = {} -- [player] -> last seen Y position
local playerToLastZ = {} -- [player] -> last seen Z position

local blockingPlayers = {} -- [player] -> true/false
-- Whether this player's movement is being blocked due to large change in position.
-- once the player sends a `lockMovementAck`, we can accept it's positions again.

local blockingPlayersAckNumber = {} -- [player] -> lockMovement ack number. (More info below)
-- ^^^ this is just done so players can't cheat by spamming `lockMovementAck`


local function shouldAccept(player)
    return not blockingPlayers[player] 
end

local FORCE_SYNC_THRESHOLD = 100 -- this number seems quite significant to force a sync.


local function forceSyncPlayerPosition(player_ent, x, y, z)
    if blockingPlayers[player_ent] then
        return -- we are already waiting on a response
    end
    local ack_number = math.random(1,100000) -- we also send a random number so the client can't lie.
    blockingPlayersAckNumber[player_ent] = ack_number
    blockingPlayers[player_ent] = true
    playerToLastX[player_ent] = x
    playerToLastY[player_ent] = y
    if z then
        playerToLastZ[player_ent] = z
    end
    server.unicast(player_ent.controller, "lockMovement", player_ent, x, y, z, ack_number)
end



umg.on("gameUpdate", function(dt)
    --[[
        Explanation for this code:
        This code is quite scuffed. Basically, the issue here is that if
        the server tries to move the client,
    ]]
    for _, player in ipairs(playerGroup) do
        -- `player` is a player entity.

        local x,y,z = player.x,player.y,player.z
        local lx,ly,lz = playerToLastX[player] or x, playerToLastY[player] or y, playerToLastZ[player] or z

        if math.distance(x-lx,y-ly,(z or 0)-(lz or 0)) > FORCE_SYNC_THRESHOLD then
            -- Distance is too large: we warrant server forced sync.
            forceSyncPlayerPosition(player, x, y, z)
        end
    end
end)


server.on("lockMovementAck", function(sender_username, player_ent, ack_number)
    if not umg.exists(player_ent) then
        return
    end
    if sender_username ~= player_ent.controller then
        return
    end
    if ack_number ~= blockingPlayersAckNumber[player_ent] then
        return -- nope, need verification, no spamming
    end

    blockingPlayers[player_ent] = nil -- no longer blocking.
    blockingPlayersAckNumber[player_ent] = nil
end)




local function filterPlayerPosition(sender_username, ent, x,y,z)
    if not umg.exists(ent) then
        return false -- DENY! Non existant entity
    end
    if type(x) ~= "number" or type(y) ~= "number" or (z and (type(z) ~= "number")) then
        return false -- bad type for x,y, or z
    end
    if State.getCurrentState() ~= "game" then
        return false -- game is probably paused
        -- TODO: This is kinda hacky and shitty
    end

    local basics = ent.controllable and sender_username == ent.controller and ent.x and ent.y
    if not basics then
        return false
    end

    local dist = math.distance(ent.x-x, ent.y-y, ent.z-z)
    if dist > FORCE_SYNC_THRESHOLD then
        -- TODO: This forceSync call is bad, ddos opportunity here.
        -- Perhaps we should instead mark this entity as "should force sync"
        -- and then sync once on the next tick?
        -- with this setup, hacked clients could send multiple position packets per frame and ddos the server
        forceSyncPlayerPosition(ent, ent.x, ent.y, ent.z)
        return false -- ent moving too fast!
    end

    if not shouldAccept(ent) then
        return false
    end

    return true
end



local function filterPlayerVelocity(sender_username, ent, vx,vy,vz)
    if not umg.exists(ent) then
        return false -- DENY! Non existant entity
    end
    if not shouldAccept(ent) then
        return false
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

    playerToLastX[ent] = x
    playerToLastY[ent] = y
    if z then
        playerToLastZ[ent] = z
    end
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

