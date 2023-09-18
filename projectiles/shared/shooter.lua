
require("projectiles_events")


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
        --[[
            TODO: 
            Here, on clientside, we should add options for more interesting stuff.
            such as playing sfx, particles, etc.
        ]]
    end
end


local DEFAULT_MODE = 1


local function callShoot(holderEnt, item, shooter)
    umg.call("projectiles:useGun", holderEnt, item, shooter)
    shoot(holderEnt, item, shooter)
end


local function tryShoot(holderEnt, item, mode)
    local shooter = item.shooter
    if isValid(shooter) then
        local shmode = shooter.mode or DEFAULT_MODE
        if shmode == mode then
            callShoot(holderEnt, item, shooter)
        end
    end

    for _, shooter_ in ipairs(shooter) do
        -- there are multiple shoot modes!
        if shooter_.mode == mode then
            -- linear search is bad, its fine tho
            -- There generally shouldn't be that many shoot modes, so it's prolly fine
            callShoot(holderEnt, item, shooter)
        end
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
        local shooter = item.shooter
        assert(type(shooter) == "table", "ent.shooter needs to be a table")
        tryShoot(holderEnt, item, mode)
    end
end)




