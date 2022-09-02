


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
        table.insert(buffer, entities.brute(0,0))
    end
    return buffer
end



return pve

