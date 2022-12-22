


local DEFAULT_COLOR = {0.3,0.3,0.3}


--[[
    [enemy] -> cost
]]
local enemyCosts = {
    brute = 1,
    huhu = 0.2,
    slime = 0.5,
}


local pve = {}


function pve.generateEnemies(turn)
    local buffer = {}
    for i=1,2 do
        local ent = server.entities.brute(0,0)
        table.insert(buffer, ent)
        ent.color = DEFAULT_COLOR
    end
    return buffer
end



return pve

