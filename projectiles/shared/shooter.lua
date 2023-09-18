

local shooterServer
if server then
    shooterServer = require("server.shooter")
end



local VALID_OPTIONS = {
    -- if `ent.shooter` has any of these values,
    -- then it is regarded as a valid shooter config:
    "spawnProjectile",
    "projectileType",
    "count"
}


local function isValid(shComp)
    for _, opt in ipairs(VALID_OPTIONS) do
        if shComp[opt] then
            return true
        end
    end
    return false
end


local shoot
if server then
    shoot = require("server.shooter")
elseif client then
    function shoot(holderEnt, item, shooter)
        
    end
end


local DEFAULT_MODE = 1

local function tryShoot(holderEnt, item, mode)
    assert(server, "not on server")
    local shooter = item.shooter
    assert(type(shooter) == "table", "wot wot???")

    if isValid(shooter) then
        print("mode: ", mode)
        local shmode = shooter.mode or DEFAULT_MODE
        if shmode == mode then
            -- shoot:
            shoot(holderEnt, item, shooter)
        end
    end

    for _, shooter_ in ipairs(shooter) do
        -- there are multiple shoot modes!
        if shooter_.mode == mode then
            -- linear search is bad, its fine tho
            -- There generally shouldn't be that many shoot modes, so it's prolly fine
            shoot(holderEnt, item, shooter_)
        end
    end





    if server then
        shooterServer.useItem(holderEnt, item, mode)
    elseif client then
        -- TODO: wtf do we do here?
        -- perhaps emit particles? provide api for playing sounds?
        -- Or we could just emit an event?
    end
end




umg.on("usables:useItem", function(holderEnt, item, mode) 
    local targX, targY = holderEnt.lookX, holderEnt.lookY
    if (not targX) or (not targY) then
        return
    end
    if (not holderEnt.x) or (not holderEnt.y) then
        return
    end

    if item.shooter then
        tryShoot(holderEnt, item, mode)
    end
end)




