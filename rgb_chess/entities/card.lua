
local function assertOptions(options)
    assert(options,"?")
    assert(options.rgbTeam, "needs rgbTeam")
    assert(options.cardBuyTarget, "needs cardBuyTarget")
    assert(options.shopIndex, "needs shopIndex")
end


--[[
    Unit card entity
]]
return {
    rgbCard = true,
    scale = 2,

    onClick = true,

    initXY = true,

    init = function(e,x,y,options)
        assertOptions(options)
        for k,v in pairs(options)do
            e[k] = v
        end
    end
}


