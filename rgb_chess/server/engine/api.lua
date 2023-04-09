
local rgbAPI = {}



local buffTc = base.typecheck.assert("entity", "string", "number", "entity?", "number?")

function rgbAPI.buff(ent, buffType, amount, sourceEnt, depth)
    buffTc(ent, buffType, amount, sourceEnt, depth)
    depth = depth or 0
    assert(constants.BUFF_TYPES[buffType], "Invalid bufftype")
    local team = ent.rgbTeam
    local player = base.getPlayer(team)
    local x,y = player.x, player.y
    if umg.exists(sourceEnt) then
        x,y = sourceEnt.x, sourceEnt.y
    end
    server.entities.projectile(x, y, {
        projectileType = constants.PROJECTILE_TYPES.BUFF,
        targetEntity = ent,
        sourceEntity = sourceEnt,
        buffAmount = amount,
        depth = depth
    })
end



local healTc = base.typecheck.assert("entity", "number", "entity?", "number?")

function rgbAPI.heal(ent, amount, sourceEnt, depth)
    healTc(ent, amount, sourceEnt, depth)

end


local shieldTc = base.typecheck.assert("entity", "number", "entity?", "number?")

function rgbAPI.shield(ent, amount, sourceEnt, depth)
    shieldTc(ent, amount, sourceEnt, depth)
    
    local team = ent.rgbTeam
    local player = base.getPlayer(team)
    local x,y = player.x, player.y
    if umg.exists(sourceEnt) then
        x,y = sourceEnt.x, sourceEnt.y
    end
    server.entities.projectile(x, y, {
        projectileType = constants.PROJECTILE_TYPES.BUFF,
        targetEntity = ent,
        sourceEntity = sourceEnt,
        buffAmount = amount,
        depth = depth
    })
end


_G.rgbAPI = rgbAPI
umg.expose("rgbAPI", rgbAPI)
