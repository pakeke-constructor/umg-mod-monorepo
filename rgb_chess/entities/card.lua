
local function assertOptions(options)
    assert(options,"?")
    assert(options.rgbTeam, "needs rgbTeam")
    assert(options.cardInfo, "needs cardInfo")
    assert(options.cardType, "needs cardType")
end



--[[
    Unit card entity
]]
return {
    card = true,

    onClick = function()
        if button == 1 and ent.rgbTeam == username then
            if server then
                if buy.tryBuy(ent) then
                    reroll.rerollSingle(ent.rgbTeam, ent.shopIndex)
                end
            elseif client then
                -- idk, play sound here or something?
            end
        end
    end,

    init = function(e,x,y,options)
        assertOptions(options)
        for k,v in pairs(options)do
            e[k] = v
        end

        base.initializers.initXY(e,x,y)
    end
}


