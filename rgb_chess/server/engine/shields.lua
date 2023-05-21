
local abilities = require("server.abilities.abilities")


local shieldAPI = { }

local function getBestShield(shields)
    -- We take the shield with the lowest time to live first
    if not shields then
        return nil
    end
    local bestTime = math.huge
    local bestShield = nil
    local bestIndex = 0
    for i, shield in ipairs(shields)do
        local endTime = shield.startTime + shield.duration
        if (not bestShield) or endTime < bestTime then
            bestShield = shield
            bestTime = endTime
            bestIndex = i
        end
    end
    return bestShield, bestIndex
end


local function breakShield(ent, shield)
    -- TODO: Get this working properly.
    abilities.trigger("allyShieldBreak", ent.rgbTeam)
    umg.call("breakShield", ent, shield)    
end



function shieldAPI.getDamage(ent, damage)
    assert(umg.exists(ent),"?")
    local shields = ent.shields
    local shield, index = getBestShield(shields)
    while shield and damage > 0 do
        local shSize = shield.shieldSize
        shield.shieldSize = shSize - damage
        damage = damage - shSize
        if shield.shieldSize <= 0 then
            table.remove(shields, index)
            breakShield(ent, shield)
        end
        shield, index = getBestShield(shields)
    end
    return math.max(damage, 0)
end





local createShieldTc = typecheck.assert("entity", "number", "number")

function shieldAPI.createShield(targetEnt, size, duration)
    createShieldTc(targetEnt, size, duration)
    local shield = {
        startTime = base.getGameTime(),
        shieldSize = size,
        duration = duration
    }
    local shields = targetEnt.shields or {}
    table.insert(shields, shield)
    targetEnt.shields = shields
end






local shieldGroup = umg.group("shields")


local function expireShields(ent)
    local shields = ent.shields
    local time = base.getGameTime()
    for i, sh in ipairs(shields)do
        local endTime = sh.duration + sh.startTime
        if endTime > time then
            -- Remove the shield, it's expired.
            abilities.trigger("allyShieldExpire", ent.rgbTeam)
            umg.call("shieldExpire", ent, sh.shieldSize)
            table.remove(shields, i)
        end
    end
end

umg.on("@tick", function()
    for _, ent in ipairs(shieldGroup) do
        if ent.shields then
            expireShields(ent)
        end
    end
end)



return shieldAPI
